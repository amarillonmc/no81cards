local m=15000762
local cm=_G["c"..m]
cm.name="幻象骑士·铜之奈勒"
function cm.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	--move
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.mocon)
	e1:SetOperation(cm.moop)
	c:RegisterEffect(e1)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_CUSTOM+15000762)
	e2:SetCountLimit(1,15000762)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(cm.sptg1)
	e2:SetOperation(cm.spop1)
	c:RegisterEffect(e2)
	--?
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,15000763)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.con)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	if not c15000762.global_check then
		c15000762.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_MOVE)
		ge1:SetCondition(cm.regcon)
		ge1:SetOperation(cm.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.cfilter(c)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil)
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RaiseEvent(eg,EVENT_CUSTOM+15000762,re,r,rp,ep,ev)
end
function cm.mocon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	return ((Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1)) or (Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0))) and not Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c)
end
function cm.moop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if Duel.IsExistingMatchingCard(nil,tp,LOCATION_PZONE,0,1,c) then return end
	if Duel.GetFieldCard(tp,LOCATION_PZONE,0)==c and Duel.CheckLocation(tp,LOCATION_PZONE,1) then
		Duel.MoveSequence(c,4)
	elseif Duel.GetFieldCard(tp,LOCATION_PZONE,1)==c and Duel.CheckLocation(tp,LOCATION_PZONE,0) then
		Duel.MoveSequence(c,0)
	end
end
function cm.sptg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function cm.spop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
end
function cm.sr1filter(c)
	return c:IsSetCard(0x3f3c) and c:IsType(TYPE_MONSTER) and not c:IsCode(15000762) and c:IsAbleToHand()
end
function cm.sr2filter(c)
	return c:IsAbleToHand() and c:IsCanHaveCounter(0xf3c,1) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b1=(Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1)
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.IsExistingMatchingCard(cm.sr1filter,tp,LOCATION_DECK,0,1,nil))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(cm.sr2filter,tp,LOCATION_DECK,0,1,nil))
	return b1 and (b2 or b3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local tp=c:GetControler()
	if chk==0 then return Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==1 end
	e:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local b2=(Duel.GetFieldCard(tp,LOCATION_PZONE,0) and Duel.IsExistingMatchingCard(cm.sr1filter,tp,LOCATION_DECK,0,1,nil))
	local b3=(Duel.GetFieldCard(tp,LOCATION_PZONE,1) and Duel.IsExistingMatchingCard(cm.sr2filter,tp,LOCATION_DECK,0,1,nil))
	if Duel.GetMatchingGroupCount(nil,tp,LOCATION_PZONE,0,nil)==0 then return end
	local op=0
	if b2 and b3 then op=Duel.SelectOption(tp,aux.Stringid(m,0),aux.Stringid(m,1))
	elseif b2 and not b3 then op=Duel.SelectOption(tp,aux.Stringid(m,0))
	elseif b3 and not b2 then op=Duel.SelectOption(tp,aux.Stringid(m,1))+1
	else return end
	local tc=nil
	if op==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=Duel.SelectMatchingCard(tp,cm.sr1filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	end
	if op==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		tc=Duel.SelectMatchingCard(tp,cm.sr2filter,tp,LOCATION_DECK,0,1,1,nil):GetFirst()
	end
	if tc then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end