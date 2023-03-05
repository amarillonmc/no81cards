--天花乱漫-彼岸之景
local m=14001213
local cm=_G["c"..m]
cm.named_with_Blossom_Blade=1
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_NEGATE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,2))
	e2:SetCategory(CATEGORY_LEAVE_GRAVE+CATEGORY_TOGRAVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.settg)
	e2:SetOperation(cm.setop)
	c:RegisterEffect(e2)
end
function cm.BB(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Blossom_Blade
end
function cm.cfilter(c)
	return c:IsFaceup() and cm.BB(c)
end
function cm.cpfilter(c)
	if not (cm.BB(c) and c:IsType(TYPE_MONSTER)) then return false end
	local m1=_G["c"..c:GetCode()]
	if not m1 then return false end
	local te=m1.selfsummon_effect
	return te
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsChainNegatable(ev)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and Duel.IsExistingMatchingCard(cm.cpfilter,tp,LOCATION_MZONE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		local g=Duel.SelectMatchingCard(tp,cm.cpfilter,tp,LOCATION_MZONE,0,1,1,nil)
		local tc=g:GetFirst()
		if tc and tc:IsFaceup() then
			local m1=_G["c"..tc:GetCode()]
			local te=m1.selfsummon_effect
			local op=te:GetOperation()
			if op then op(e,tp,eg,ep,ev,re,r,rp) end
		end
	end
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and (cm.BB(c) or (c:IsOnField() and c:IsPosition(POS_FACEUP_ATTACK)))and c:IsType(TYPE_MONSTER) and (not c:IsOnField() or c:IsFaceup())
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) and e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_HAND+LOCATION_MZONE)
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil)
	if #g>0 then
		if Duel.SendtoGrave(g,REASON_EFFECT)~=0 and c:IsRelateToEffect(e) then
			Duel.SSet(tp,c)
		end
	end
end