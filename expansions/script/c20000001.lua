--史黛拉-EX
function c20000001.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnableChangeCode(c,20000000,LOCATION_MZONE)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c20000001.con2)
	e2:SetOperation(c20000001.op2)
	c:RegisterEffect(e2)
	--imm
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20000001,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c20000001.co3)
	e3:SetOperation(c20000001.op3)
	c:RegisterEffect(e3)
	--Break
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20000001,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,20000001)
	e4:SetCost(c20000001.co4)
	e4:SetTarget(c20000001.tg4)
	e4:SetOperation(c20000001.op4)
	c:RegisterEffect(e4)
	--cannot link material
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e5:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e5:SetValue(1)
	c:RegisterEffect(e5)
end
function c20000001.conf2(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0x5fd1) and c:IsFaceup()
end
function c20000001.conf21(g,tp,sc)
	return g:GetCount()==5
		and g:IsExists(c20000001.conf2,5,nil)
end
function c20000001.con2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c20000001.conf2,tp,LOCATION_REMOVED,0,nil)
	return g:CheckSubGroup(c20000001.conf21,5,5,tp,c) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c20000001.op2(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c20000001.conf2,tp,LOCATION_REMOVED,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local tg=g:SelectSubGroup(tp,c20000001.conf21,false,5,5,tp,c)
	Duel.SendtoDeck(tg,nil,2,REASON_COST)
end
function c20000001.cof3(c)
	return c:IsAbleToGraveAsCost()
end
function c20000001.co3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20000001.cof3,tp,LOCATION_ONFIELD,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20000001.cof3,tp,LOCATION_ONFIELD,0,1,1,e:GetHandler())
	Duel.SendtoGrave(g,REASON_COST)
end
function c20000001.tgf3(c,tp)
	return c:IsSetCard(0x5fd1) and (c:GetType()==0x20002 or c:GetType()==0x20004)
		and c:GetActivateEffect():IsActivatable(tp,true,true)
end
function c20000001.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_IMMUNE_EFFECT)
		e1:SetValue(c20000001.val3)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e2:SetValue(1)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e2)
		Duel.BreakEffect()
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c20000001.tgf3),tp,LOCATION_GRAVE,0,nil)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(20000001,2)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local g=Duel.SelectMatchingCard(tp,c20000001.tgf3,tp,LOCATION_GRAVE,0,1,1,nil,tp)
			local tc=g:GetFirst()
			if tc then
				local b2=tc:GetActivateEffect():IsActivatable(tp)
				if b2 then
					Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
					local te=tc:GetActivateEffect()
					local tep=tc:GetControler()
					local cost=te:GetCost()
					if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
				end
			end
		end
	end
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(20000001,3))
end
function c20000001.val3(e,re)
	return not (re:GetOwner():IsSetCard(0x5fd1) or re:GetOwner()==e:GetOwner())
end
function c20000001.cof4(c)
	return c:IsAbleToDeckOrExtraAsCost() and c:IsSetCard(0x5fd1) and c:IsFaceup()
end
function c20000001.co4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20000001.cof4,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c20000001.cof4,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c20000001.tg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,2,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,2,0,0)
end
function c20000001.op4(e,tp,eg,ep,ev,re,r,rp)
	local g3=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if g3:GetCount()>0 then
		local ct=math.min(g3:GetCount(),2)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local sg=g3:Select(tp,1,ct,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	end
end