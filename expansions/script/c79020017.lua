--整合运动·无人机-御4
function c79020017.initial_effect(c)
	 --def up
	 local e1=Effect.CreateEffect(c)
	 e1:SetType(EFFECT_TYPE_FIELD)
	 e1:SetRange(LOCATION_MZONE)
	 e1:SetTargetRange(LOCATION_MZONE,0)
	 e1:SetCode(EFFECT_UPDATE_DEFENSE)
	 e1:SetValue(1000)
	 c:RegisterEffect(e1)
	 --recycle
	 local e2=Effect.CreateEffect(c)
	 e2:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	 e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	 e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	 e2:SetCode(EVENT_DESTROYED)
	 e2:SetTarget(c79020017.target)
	 e2:SetOperation(c79020017.activate)
	 c:RegisterEffect(e2)
	 --SpecialSummon
	 local e3=Effect.CreateEffect(c)
	 e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	 e3:SetType(EFFECT_TYPE_IGNITION)
	 e3:SetRange(LOCATION_GRAVE)
	 e3:SetCode(EVENT_FREE_CHAIN)
	 e3:SetTarget(c79020017.sptg)
	 e3:SetOperation(c79020017.spop)
	 c:RegisterEffect(e3)
	 --Destroy
	 local e4=Effect.CreateEffect(c)
	 e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	 e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	 e4:SetCode(EVENT_LEAVE_FIELD_P)
	 e4:SetOperation(c79020017.checkop)
	 c:RegisterEffect(e4)
	 local e5=Effect.CreateEffect(c)
	 e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	 e5:SetCode(EVENT_LEAVE_FIELD)
	 e5:SetOperation(c79020017.desop)
	 e5:SetLabelObject(e4)
	 c:RegisterEffect(e5)
	 --Destroy2
	 local e6=Effect.CreateEffect(c)
	 e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	 e6:SetRange(LOCATION_SZONE)
	 e6:SetCode(EVENT_LEAVE_FIELD)
	 e6:SetCondition(c79020017.descon2)
	 e6:SetOperation(c79020017.desop2)
	 c:RegisterEffect(e6)
if not c79020017.global_check then
		c79020017.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
		ge1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)   
		ge1:SetTarget(aux.TargetBoolFunction(Card.IsCode,79020017 and Card.IsType,TYPE_EQUIP+TYPE_SPELL))
		ge1:SetValue(LOCATION_REMOVED)
		Duel.RegisterEffect(ge1,0)
	end
end
function c79020017.filter(c)
	return c:IsSetCard(0x3900) and c:IsAbleToDeck()
end
function c79020017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c79020017.filter(chkc) end
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2)
		and Duel.IsExistingTarget(c79020017.filter,tp,LOCATION_GRAVE,0,5,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c79020017.filter,tp,LOCATION_GRAVE,0,5,5,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
end
function c79020017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not tg or tg:FilterCount(Card.IsRelateToEffect,nil,e)~=5 then return end
	Duel.SendtoDeck(tg,nil,0,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	if g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK) then Duel.ShuffleDeck(tp) end
	local ct=g:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
	if ct==5 then
		Duel.BreakEffect()
		Duel.Draw(tp,2,REASON_EFFECT)
	end
end
function c79020017.filter1(c,e,tp)
	return c:IsSetCard(0x3900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79020017.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_GRAVE and chkc:GetControler()==tp
		and chkc:IsCanBeSpecialSummoned(e,0,tp,false,false) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingTarget(c79020017.filter1,tp,LOCATION_GRAVE,0,1,e:GetHandler(),e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c79020017.filter1,tp,LOCATION_GRAVE,0,1,1,e:GetHandler(),e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c79020017.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e)
		and Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP) then
		c:SetCardTarget(tc)
		Duel.SpecialSummonComplete()
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EQUIP_LIMIT)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetValue(c79020017.eqlimit)
	c:RegisterEffect(e3)
	if Duel.Equip(tp,c,tc)~=0 then  
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SPELL+TYPE_EQUIP)
	e1:SetReset(RESET_EVENT+EVENT_REMOVE)
	c:RegisterEffect(e1)
	end
end
end
function c79020017.eqlimit(e,c)
	return c:IsSetCard(0x3900)
end
function c79020017.checkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsDisabled() then
		e:SetLabel(1)
	else e:SetLabel(0) end
end
function c79020017.desop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetLabelObject():GetLabel()~=0 then return end
	local tc=e:GetHandler():GetFirstCardTarget()
	if tc and tc:IsLocation(LOCATION_MZONE) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c79020017.descon2(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler():GetFirstCardTarget()
	return tc and eg:IsContains(tc)
end
function c79020017.desop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end