class TimingDashboard extends React.Component {
  constructor() {
    super();

    this.onChange = this.onChange.bind(this);

    this.state = {
      show: false
    }
  }

  onChange() {
    const show = DraftResultStore.getRaceId() && DraftResultStore.getRaceType() !== 'penjanje';
    this.setState({ show })
  }

  componentDidMount() {
    DraftResultStore.on('draftResultStore.setRace', this.onChange);
  }

  componentWillUnmount() {
    DraftResultStore.off('draftResultStore.setRace', this.onChange);
  }

  createRaceResult(event, status = 3) {
    let input = document.getElementById('raceResultInput');

    if((event.keyCode == 13 || event.type === 'click') && input.value.length) {
      let startNumber = parseInt(input.value);
      let time = status === 3 ? timeSync.now() : null;
      if(startNumber) {
        RaceResultActions.newRaceResult(startNumber, time, status);
        input.value = '';
      }
      else {
        alert('Pogresan broj. Pokusaj ponovno.');
      }
    }
  }

  render () {
    return (
      <div className={`${this.state.show ? '' : 'hidden'} mdl-grid`}>
        <div className="mdl-cell mdl-cell--6-col" style={{border: '1px solid #aaa', padding: '1em', marginLeft: '-1em'}}>
          <h4 style={{marginLeft: '20px'}}>Unesi startni broj</h4>
          <input type="number" min="1" id="raceResultInput" onKeyUp={ event => this.createRaceResult(event) } />
          <ul className="list-unstyled">
            <li
              className="mdl-button mdl-js-button mdl-button--raised mdl-button--colored mdl-js-ripple-effect"
              onClick={ (event) => this.createRaceResult(event) }
            >
              Spremi
            </li>
            <li
              className="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect"
              onClick={ (event) => this.createRaceResult(event, 4) }
            >
              DNF
            </li>
            <li
              className="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect"
              onClick={ (event) => this.createRaceResult(event, 5) }
            >
              DSQ
            </li>
            <li
              className="mdl-button mdl-js-button mdl-button--raised mdl-button--accent mdl-js-ripple-effect"
              onClick={ (event) => this.createRaceResult(event, 6) }
            >
              DNS
            </li>
          </ul>
          <hr/>
          <TempResults />
          <hr/>
          <RaceResultForm />
          {
            DraftResultStore.getRaceType() == 'treking' ?
            (
              <div>
                <hr/>
                <MissedControlPointsForm />
              </div>
            )
            :
            null
          }
        </div>
        <div className="mdl-cell mdl-cell--6-col">
          <DraftResults />
        </div>
        {
          this.state.show ?
          (<div className="mdl-cell mdl-cell--12-col">
            <RaceResults raceId={DraftResultStore.getRaceId()} />
          </div>)
          :
          null
        }
      </div>
    );
  }
}
