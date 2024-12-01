--远古造物栖所 冈瓦纳
dofile("expansions/script/c9910700.lua")
function c9910727.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,9910727+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c9910727.activate)
	c:RegisterEffect(e1)
	--atk down
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(c9910727.atkval)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--set
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(9910727,1))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_REMOVE)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetTarget(c9910727.settg)
	e4:SetOperation(c9910727.setop)
	c:RegisterEffect(e4)
end
function c9910727.filter(c)
	return c:IsSetCard(0xc950) and c:IsType(TYPE_SPELL+TYPE_TRAP) and not c:IsType(TYPE_FIELD) and c:IsSSetable()
end
function c9910727.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c9910727.filter,tp,LOCATION_DECK,0,nil)
	if #g>0 and Duel.SelectYesNo(tp,aux.Stringid(9910727,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local sc=g:Select(tp,1,1,nil):GetFirst()
		Duel.SSet(tp,sc)
	end
end
function c9910727.atkval(e)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,e:GetHandlerPlayer(),LOCATION_GRAVE,0,nil,0xc950)*-50
end
function c9910727.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_EFFECT_ENABLED)
end
function c9910727.setfilter(c,e)
	if not (c:IsFaceup() and c:IsType(TYPE_MONSTER)) then return false end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1,true)
	local res=c:IsSSetable(true)
	e1:Reset()
	return res
end
function c9910727.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_REMOVED) and c9910727.setfilter(chkc,e) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectTarget(tp,c9910727.setfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e)
end
function c9910727.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEDOWN,true) then
		Duel.ConfirmCards(1-tp,tc)
		Duel.RaiseEvent(tc,EVENT_SSET,e,REASON_EFFECT,tp,tp,0)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
		e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		tc:RegisterEffect(e1)
	end
end
