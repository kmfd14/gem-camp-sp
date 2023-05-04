import {Controller} from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["email"]

    copy() {
        navigator.clipboard.writeText(this.emailTarget.textContent);
        $(".notice:eq(0)").text('copy email: ' + this.emailTarget.textContent);
    }
}