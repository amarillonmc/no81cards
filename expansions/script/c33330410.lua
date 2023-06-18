--恶梦启示 怨恨
local m=33330410
local cm=_G["c"..m]
function cm.initial_effect(c)
	c:EnableReviveLimit()
	--aux.AddLinkProcedure(c,cm.lfilter,2)
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_FIEND),2,2,cm.lcheck)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,2))
	e1:SetCategory(CATEGORY_LEAVE_GRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND+CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+100)
	e2:SetCondition(cm.dcheck)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
	--cannot be target/indestructable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	c:RegisterEffect(e4)
	local e5=e3:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
end
--function cm.lfilter(c)
	--return c:IsLinkRace(RACE_FIEND) --and not c:IsSummonableCard()
--end
function cm.lcheck(g,lc)
	return g:IsExists(Card.IsSetCard,1,nil,0x6552)
end
function cm.indcon(e)
	return e:GetHandler():GetLinkedGroupCount()>0
end
function cm.tfilter(g,tp)
	local g1=g:Filter(Card.IsControler,nil,tp)
	local g2=g:Filter(Card.IsControler,nil,1-tp)
	return Duel.GetLocationCount(tp,LOCATION_SZONE)>=g1:GetCount() and Duel.GetLocationCount(1-tp,LOCATION_SZONE)>=g2:GetCount() 
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsType,1,nil,TYPE_MONSTER)
end
function cm.tfcheck(c)
	return c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local dg=eg:Filter(cm.tfcheck,nil,TYPE_MONSTER)
	if chk==0 then return dg:CheckSubGroup(cm.tfilter,1,2,tp) end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,rg,1,0,0)
end
function cm.op(e,tp,eg)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELECT)
	local dg=eg:Filter(cm.tfcheck,nil,TYPE_MONSTER)
	local tg=dg:SelectSubGroup(tp,cm.tfilter,false,1,2,tp)
	if #tg<=0 then return end
	Duel.HintSelection(tg)
	for tc in aux.Next(tg) do
		if Duel.MoveToField(tc,tp,tc:GetControler(),LOCATION_SZONE,POS_FACEUP,true) then 
			local e1=Effect.CreateEffect(c)
			e1:SetCode(EFFECT_CHANGE_TYPE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_CHANGE_CODE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET)
			e2:SetValue(m)
			tc:RegisterEffect(e2,true)
		end
	end
end
function cm.dcheck(e,tp)
	local lg=e:GetHandler():GetLinkedGroup()
	return lg:IsExists(cm.cfilter,1,nil)
end
function cm.cfilter(c)
	return ((c:IsFacedown() or c:IsPosition(POS_FACEUP_ATTACK)) and c:IsCanChangePosition())  or (c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanTurnSet())
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSetCard(0x6552)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function cm.thop(e,tp)
	local lg=e:GetHandler():GetLinkedGroup()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tg=lg:FilterSelect(tp,cm.cfilter,1,1,nil)
	if tg:GetCount()==0 then return end
	local tc=tg:GetFirst()
	local prepos=tc:GetPosition()
	if tc:IsFaceup() then 
		if tc:IsPosition(POS_FACEUP_ATTACK) then
			if c:IsCanTurnSet() then
				Duel.SelectPosition(tp,tc,POS_FACEUP_DEFENSE|POS_FACEDOWN_DEFENSE)
			else
				Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
			end
		else
			Duel.ChangePosition(tc,POS_FACEDOWN_DEFENSE)
		end 
	else 
		Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)
	end
	local pos=tc:GetPosition()
	if pos~=prepos then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local tg=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #tg>0 then
			Duel.SendtoHand(tg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tg)
		end 
	end
end