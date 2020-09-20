--智脑-000 Orga
function c9980454.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.ritlimit)
	c:RegisterEffect(e1)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x9bca))
	e1:SetTargetRange(LOCATION_HAND,0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	c:RegisterEffect(e2)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(9980454,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(c9980454.descon)
	e2:SetTarget(c9980454.destg)
	e2:SetOperation(c9980454.desop)
	c:RegisterEffect(e2)
	--draw
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetDescription(aux.Stringid(9980454,1))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,9980454)
	e5:SetTarget(c9980454.drtg)
	e5:SetOperation(c9980454.drop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetLabelObject(e5)
	e6:SetOperation(c9980454.regop)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_CHAIN_NEGATED)
	e7:SetOperation(c9980454.regop2)
	c:RegisterEffect(e7)
	local e8=e6:Clone()
	e8:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	e8:SetOperation(c9980454.clearop)
	c:RegisterEffect(e8)
	--spsummon bgm
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_SPSUMMON_SUCCESS)
	e8:SetOperation(c9980454.sumsuc)
	c:RegisterEffect(e8)
end
function c9980454.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980454,0)) 
end 
function c9980454.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c9980454.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c9980454.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980454,1)) 
	Duel.Destroy(g,REASON_EFFECT)
end
function c9980454.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local d=e:GetLabel()
	if chk==0 then return d>0 and Duel.IsPlayerCanDraw(tp,d) end
	Duel.SetTargetPlayer(tp)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,d)
end
function c9980454.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local d=e:GetLabel()
	if d>0 then
		Duel.Hint(HINT_MUSIC,0,aux.Stringid(9980454,2)) 
		Duel.Draw(p,d,REASON_EFFECT)
	end
end
function c9980454.regop(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x9bca) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local val=e:GetLabelObject():GetLabel()
		e:GetLabelObject():SetLabel(val+1)
	end
end
function c9980454.regop2(e,tp,eg,ep,ev,re,r,rp)
	if re:GetHandler():IsSetCard(0x9bca) and rp==tp and re:IsHasType(EFFECT_TYPE_ACTIVATE) then
		local val=e:GetLabelObject():GetLabel()
		if val==0 then val=1 end
		e:GetLabelObject():SetLabel(val-1)
	end
end
function c9980454.clearop(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end