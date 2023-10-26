using Godot;
using System.Collections.Generic;

[Tool]
public partial class ComEventEmitter : Node
{
  private Dictionary<string, Dictionary<ulong, Node>> emitters { get; }
    = new Dictionary<string, Dictionary<ulong, Node>>();
  private Dictionary<string, Dictionary<ulong, (Node, Callable)>> listeners { get; }
    = new Dictionary<string, Dictionary<ulong, (Node, Callable)>>();

  private bool shouldLogEventEmitter = true;

  private void LogConnection(string SignalName, Node Listener, Node Emitter)
  {
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Connect", Emitter, "to", Listener);
  }
  private void LogDisconnection(string SignalName, Node Listener, Node Emitter)
  {
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Disconnect", Emitter, "from", Listener);
  }

  public override void _EnterTree()
  {
    Node config = GetNodeOrNull("/root/Game");
    if (config != null)
      shouldLogEventEmitter = (bool)config.Get("shouldLogEventEmitter");
  }

  public void AddEmitter(string SignalName, Node Emitter)
  {
    if (!emitters.ContainsKey(SignalName))
      emitters.Add(SignalName, new Dictionary<ulong, Node>());

    emitters[SignalName].Add(Emitter.GetInstanceId(), Emitter);
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Emitter", Emitter, "is added");

    if (!listeners.ContainsKey(SignalName)) return;
    foreach (KeyValuePair<ulong, (Node Listener, Callable Callback)> kvp in listeners[SignalName])
    {
      if (!Emitter.IsConnected(SignalName, kvp.Value.Callback))
      {
        Emitter.Connect(SignalName, kvp.Value.Callback);
        LogConnection(SignalName, kvp.Value.Listener, Emitter);
      }
    }
  }

  public void RemoveEmitter(string SignalName, Node Emitter)
  {
    if (!emitters.ContainsKey(SignalName)) return;

    ulong emitterId = Emitter.GetInstanceId();
    if (!emitters[SignalName].ContainsKey(emitterId)) return;

    emitters[SignalName].Remove(emitterId);
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Emitter", Emitter, "is removed");

    if (!listeners.ContainsKey(SignalName)) return;
    foreach (KeyValuePair<ulong, (Node Listener, Callable Callback)> kvp in listeners[SignalName])
    {
      if (Emitter.IsConnected(SignalName, kvp.Value.Callback))
      {
        Emitter.Disconnect(SignalName, kvp.Value.Callback);
        LogDisconnection(SignalName, kvp.Value.Listener, Emitter);
      }
    }
  }

  public void AddListener(string SignalName, Node Listener, Callable Callback)
  {
    if (!listeners.ContainsKey(SignalName))
      listeners.Add(SignalName, new Dictionary<ulong, (Node, Callable)>());

    listeners[SignalName].Add(Listener.GetInstanceId(), (Listener, Callback));
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Listener", Listener, "is added");

    if (!emitters.ContainsKey(SignalName)) return;
    foreach (KeyValuePair<ulong, Node> kvp in emitters[SignalName])
    {
      if (!kvp.Value.IsConnected(SignalName, Callback))
      {
        kvp.Value.Connect(SignalName, Callback);
        LogConnection(SignalName, Listener, kvp.Value);
      }
    }
  }

  public void RemoveListener(string SignalName, Node Listener, Callable Callback)
  {
    if (!listeners.ContainsKey(SignalName)) return;

    ulong listenerId = Listener.GetInstanceId();
    if (!listeners[SignalName].ContainsKey(listenerId)) return;

    listeners[SignalName].Remove(listenerId);
    if (shouldLogEventEmitter)
      GD.PrintS("EventEmitter:", SignalName, "Listener", Listener, "is removed");

    if (!emitters.ContainsKey(SignalName)) return;
    foreach (KeyValuePair<ulong, Node> kvp in emitters[SignalName])
    {
      if (kvp.Value.IsConnected(SignalName, Callback))
      {
        kvp.Value.Disconnect(SignalName, Callback);
        LogDisconnection(SignalName, Listener, kvp.Value);
      }
    }
  }
}
