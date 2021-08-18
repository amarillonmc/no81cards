--作战记录-Requiem
function c79029259.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_INACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c79029259.accost)
	e1:SetTarget(c79029259.actg)
	e1:SetOperation(c79029259.acop)
	c:RegisterEffect(e1)   
	--fo im 
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(79029259)
	e2:SetRange(LOCATION_FZONE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,1)
	c:RegisterEffect(e2) 

end
function c79029259.accost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,LOCATION_ONFIELD+LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA+LOCATION_GRAVE+LOCATION_REMOVED,c)
	Duel.HintSelection(Group.FromCards(c)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029259,0)) 
	Duel.Exile(g,REASON_RULE)
	Duel.HintSelection(Group.FromCards(c))
	getmetatable(e:GetHandler()).announce_filter={79029385,OPCODE_ISCODE,79029386,OPCODE_ISCODE,OPCODE_OR}
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(79029259,1))
	local ac=Duel.AnnounceCard(tp,table.unpack(getmetatable(e:GetHandler()).announce_filter))
	e:SetLabel(ac)
	Duel.HintSelection(Group.FromCards(c)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029259,2)) 
	Duel.Hint(HINT_MESSAGE,0,aux.Stringid(79029259,3)) 
end
function c79029259.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetChainLimit(aux.FALSE)
end
function c79029259.acop(e,tp,eg,ep,ev,re,r,rp)
	local ac=e:GetLabel()
	local tc=Duel.CreateToken(tp,ac)
	local m=_G["c"..tc:GetCode()]
	local te=m.copy_effect
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
	








