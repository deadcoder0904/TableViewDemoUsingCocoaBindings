import Cocoa
import Defaults

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
    var dreams = defaults[.dreams]
    @objc dynamic var selectedIndexes = IndexSet()

    @IBOutlet weak var table: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        dreams.append("")
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

    override func controlTextDidChange(_ obj: Notification) {
        saveDreams()
    }

    @IBAction func addTableRow(_ sender: Any) {
        addNewDream()
    }
    
    @IBAction func removeTableRow(_ sender: Any) {
        removeDream()
    }
    
    func saveDreams() {
        defaults[.dreams] = dreams
    }
}

