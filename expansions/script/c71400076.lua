--构异梦像-镰刀
local s,id,o=GetID()
function s.initial_effect(c)
	if not (yume and yume.yume_nikki) then
		yume=yume or {}
		yume.import_flag=true
		c:CopyEffect(71400001,0)
		yume.import_flag=false
	end
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DISABLE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(s.con)
	e1:SetTarget(s.tg)
	e1:SetOperation(s.op)
	c:RegisterEffect(e1)
	--set from grave
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,id+o)
	e2:SetCondition(s.setcon)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.con(e,tp,eg,ep,ev,re,r,rp)
	return yume.IsYumeFieldOnField(tp)
end
function s.destfilter(c)
	return c:IsOnField() and c:IsFaceup() and c:IsDestructable() and not c:IsCode(id)
end
function s.disfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x714) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_MZONE) and not c:IsCode(id)
end
function s.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(s.destfilter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,c)
	local g2=Duel.GetMatchingGroup(s.disfilter,tp,LOCATION_MZONE,LOCATION_MZONE,c)
	if chk==0 then return yume.QuickDualSelectCheck(g1,g2,{{1,1},{1,1}}) end
	local dg=yume.QuickDualSelect(tp,g1,g2,{{1,1},{1,1}},HINTMSG_DESTROY,nil,nil)
	if dg:GetCount()>0 then
		Duel.SetTargetCard(dg)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_DISABLE,g2,1,0,0)
	end
end
function s.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	if not g then return end
	local dg=g:Filter(Card.IsRelateToEffect,nil,e)
	local tc1=dg:GetFirst()
	local tc2=dg:GetNext()
	if tc1 and tc1:IsOnField() and tc1:IsRelateToChain() then
		Duel.Destroy(tc1,REASON_EFFECT)
	end
	if tc2 and tc2:IsOnField() and tc2:IsRelateToChain() then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc2:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		tc2:RegisterEffect(e2)
	end
end
function s.setcon(e,tp,eg,ep,ev,re,r,rp)
	return yume.IsYumeFieldOnField(tp)
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsSSetable() end
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SSet(tp,c)
	end
end
