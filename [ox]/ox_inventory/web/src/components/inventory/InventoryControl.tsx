import React, { useState } from 'react';
import { useDrop } from 'react-dnd';
import { useAppDispatch, useAppSelector } from '../../store';
import { selectItemAmount, setItemAmount } from '../../store/inventory';
import { DragSource } from '../../typings';
import { onUse } from '../../dnd/onUse';
import { onGive } from '../../dnd/onGive';
import { fetchNui } from '../../utils/fetchNui';
import { Locale } from '../../store/locale';
import UsefulControls from './UsefulControls';

const InventoryControl: React.FC = () => {
  const itemAmount = useAppSelector(selectItemAmount);
  const dispatch = useAppDispatch();

  const [infoVisible, setInfoVisible] = useState(false);

  const [, use] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => {
      source.inventory === 'player' && onUse(source.item);
    },
  }));

  const [, give] = useDrop<DragSource, void, any>(() => ({
    accept: 'SLOT',
    drop: (source) => {
      source.inventory === 'player' && onGive(source.item);
    },
  }));

  const inputHandler = (event: React.ChangeEvent<HTMLInputElement>) => {
    event.target.valueAsNumber =
      isNaN(event.target.valueAsNumber) || event.target.valueAsNumber < 0 ? 0 : Math.floor(event.target.valueAsNumber);
    dispatch(setItemAmount(event.target.valueAsNumber));
  };

  return (
    <>
      <UsefulControls infoVisible={infoVisible} setInfoVisible={setInfoVisible} />
      <div className="inventory-control">
        <div className="inventory-control-wrapper">
          {/* Botón info a la izquierda */}
          <div className="left-button">
            <button
              className="inventory-control-button inventory-control-button-icon inventory-control-button-info"
              onClick={() => setInfoVisible(true)}
            >
              <svg xmlns="http://www.w3.org/2000/svg" height="1.5em" viewBox="0 0 524 524">
                <path d="M256 512A256 256 0 1 0 256 0a256 256 0 1 0 0 512zM216 336h24V272H216c-13.3 0-24-10.7-24-24s10.7-24 24-24h48c13.3 0 24 10.7 24 24v88h8c13.3 0 24 10.7 24 24s-10.7 24-24 24H216c-13.3 0-24-10.7-24-24s10.7-24 24-24zm40-208a32 32 0 1 1 0 64 32 32 0 1 1 0-64z" />
              </svg>
            </button>
          </div>

          {/* Resto de los botones a la derecha */}
          <div className="right-controls">
            <input
              className="inventory-control-input"
              type="number"
              defaultValue={itemAmount}
              onChange={inputHandler}
              min={0}
            />
            <button className="inventory-control-button inventory-control-button-use" ref={use}>
              {Locale.ui_use || 'Usar'}
            </button>
            <button className="inventory-control-button inventory-control-button-give" ref={give}>
              {Locale.ui_give || 'Dar'}
            </button>
            <button className="inventory-control-button inventory-control-button-icon inventory-control-button-exit" onClick={() => fetchNui('exit')}>
              <svg xmlns="http://www.w3.org/2000/svg" height="1.5em" viewBox="0 0 512 512">
                <path d="M256 0C114.6 0 0 114.6 0 256s114.6 256 256 256
                        256-114.6 256-256S397.4 0 256 0zm93.3 330.7c12.5 12.5 12.5 
                        32.8 0 45.3s-32.8 12.5-45.3 0L256 301.3l-48 48c-12.5 
                        12.5-32.8 12.5-45.3 0s-12.5-32.8 0-45.3l48-48-48-48c-12.5-12.5-12.5-32.8 
                        0-45.3s32.8-12.5 45.3 0l48 48 48-48c12.5-12.5 32.8-12.5 
                        45.3 0s12.5 32.8 0 45.3l-48 48 48 48z"/>
              </svg>
            </button>

          </div>
        </div>
      </div>
    </>
  );
};

export default InventoryControl;
