--X抗体 多路战龙兽
function c16364053.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0xdc3),9,3,c16364053.ovfilter,aux.Stringid(16364053,3),3,c16364053.xyzop0)
	c:EnableReviveLimit()
	--attack all
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ATTACK_ALL)
	e1:SetValue(c16364053.atkfilter)
	c:RegisterEffect(e1)
	--pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16364053,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetHintTiming(0,TIMING_SSET)
	e3:SetCountLimit(1,16364053)
	e3:SetTarget(c16364053.destg)
	e3:SetOperation(c16364053.desop)
	c:RegisterEffect(e3)
	--position
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(16364053,2))
	e4:SetCategory(CATEGORY_POSITION)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CUSTOM+16364053)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,16364053+1)
	e4:SetCondition(c16364053.poscon)
	e4:SetTarget(c16364053.postg)
	e4:SetOperation(c16364053.posop)
	c:RegisterEffect(e4)
	if not c16364053.mataddcheck then
		c16364053.mataddcheck=true
		local _Overlay=Duel.Overlay
		function Duel.Overlay(card,param)
			_Overlay(card,param)
			if card:IsCode(16364053) then
				Duel.RaiseEvent(param,EVENT_CUSTOM+16364053,nil,REASON_EFFECT,0,0,0)
			end
		end
	end
end
function c16364053.ovfilter(c)
	return c:IsFaceup() and c:IsXyzType(TYPE_XYZ) and c:IsRank(7) and c:IsSetCard(0xdc3)
end
function c16364053.xyzop0(e,tp,chk,mc)
	if chk==0 then return mc:CheckRemoveOverlayCard(tp,2,REASON_COST) end
	mc:RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c16364053.atkfilter(e,c)
	return c:IsPosition(POS_DEFENSE)
end
function c16364053.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsType(TYPE_SPELL+TYPE_TRAP) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsType,tp,0,LOCATION_ONFIELD,1,nil,TYPE_SPELL+TYPE_TRAP) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsType,tp,0,LOCATION_ONFIELD,1,1,nil,TYPE_SPELL+TYPE_TRAP)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c16364053.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
function c16364053.matcheck(c,g)
	return g:IsContains(c)
end
function c16364053.poscon(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetOverlayGroup()
	return g:GetCount()>0 and eg:IsExists(c16364053.matcheck,1,nil,g)
end
function c16364053.posfilter(c)
	return not c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c16364053.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c16364053.posfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function c16364053.posop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c16364053.posfilter,tp,0,LOCATION_MZONE,nil)
	Duel.ChangePosition(g,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE,POS_FACEUP_DEFENSE)
end