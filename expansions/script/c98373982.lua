--渐幻在 丢卡利翁
function c98373982.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3,c98373982.ovfilter,aux.Stringid(98373982,0))
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetValue(aux.xyzlimit)
	c:RegisterEffect(e0)
	--xyzlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,98373982)
	e2:SetCondition(c98373982.ovcon)
	e2:SetTarget(c98373982.ovtg)
	e2:SetOperation(c98373982.ovop)
	c:RegisterEffect(e2)
	--disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c98373982.disop)
	c:RegisterEffect(e3)
	--remove(not)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98373982+1)
	e4:SetCondition(c98373982.rmcon)
	e4:SetTarget(c98373982.rmtg)
	e4:SetOperation(c98373982.rmop)
	c:RegisterEffect(e4)
end
function c98373982.cfilter(c)
	return c:IsSetCard(0xaf0) and c:IsFaceup()
end
function c98373982.ovfilter(c)
	return c:IsCode(98373970) and c:IsFaceup() and Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==Duel.GetMatchingGroupCount(c98373982.cfilter,c:GetControler(),LOCATION_MZONE,0,nil)
end
function c98373982.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function c98373982.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_EXTRA)>0 and e:GetHandler():IsType(TYPE_XYZ) end
end
function c98373982.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	if not c:IsRelateToEffect(e) or #g==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local tg=g:FilterSelect(tp,Card.IsCanOverlay,1,1,nil)
	Duel.Overlay(c,tg)
end
function c98373982.disop(e,tp,eg,ep,ev,re,r,rp)
	local code=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_CODE)
	if rp==1-tp and re:IsActivated() and e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,code) then
		Duel.NegateEffect(ev)
	end
end
function c98373982.rmcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end
function c98373982.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and rc:IsCanOverlay() and e:GetHandler():IsType(TYPE_XYZ) end
end
function c98373982.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e) and rc:IsRelateToEffect(re) then
		Duel.Overlay(c,rc)
	end
end
