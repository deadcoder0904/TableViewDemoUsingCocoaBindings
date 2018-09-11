import Cocoa
import Defaults

class Dream : NSObject {
    @objc dynamic var name : String
    init(name : String) {
        self.name = name
    }
}

extension Defaults.Keys {
    static let dreams = Defaults.Key<Array<String>>("dreams", default: [
        "Hit the gym",
        "Run daily",
        "Become a millionaire",
        "Become a better programmer",
        "Achieve your dreams"
        ])
}

class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    var dreamNames = defaults[.dreams]
    var dreams = [Dream]()
    @objc dynamic var selectedIndexes = IndexSet()

    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dreams = dreamNames.map{Dream(name: $0)}
    }
    
    override var acceptsFirstResponder : Bool {
        return true
    }
    
    override func keyDown(with theEvent: NSEvent) {
        if theEvent.keyCode == 51 {
            removeDream()
        }
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return dreams.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return dreams[row]
    }
    
    func addNewDream() {
        let last = dreams.count
        dreams.append(Dream(name: ""))
        table.insertRows(at: IndexSet(integer: last), withAnimation: .effectGap)
        table.scrollRowToVisible(last)
        table.selectRowIndexes([last], byExtendingSelection: false)
        
        // focus on the last item, add cursor & start editing
        let keyView = table.view(atColumn: 0, row: last, makeIfNecessary: false) as! NSTableCellView
        self.view.window!.makeFirstResponder(keyView.textField)
        
        saveDreams()
    }
    
    func removeDream() {
        guard let selectedRow = selectedIndexes.first else { return }
        dreams.remove(at: selectedRow)
        table.removeRows(at: IndexSet(integer: selectedRow), withAnimation: .effectFade)
        
        saveDreams()
    }

    override func controlTextDidEndEditing(_ obj: Notification) {
        saveDreams()
    }
    
    @IBAction func addTableRow(_ sender: Any) {
        addNewDream()
    }
    
    @IBAction func removeTableRow(_ sender: Any) {
        removeDream()
    }
    
    func saveDreams() {
        defaults[.dreams] = dreams.map({ $0.name })
    }
}

