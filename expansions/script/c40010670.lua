--哀恸魔女-罪业之耶里德
local s,id,o=GetID()
Duel.LoadScript("c40010663.lua")
function s.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(Card.IsRace,RACE_SPELLCASTER),1)
	c:EnableReviveLimit()
	--replace
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_BE_BATTLE_TARGET)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.cbtg)
	e1:SetOperation(s.cbop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.cecon)
	e2:SetTarget(s.cetg)
	e2:SetOperation(s.ceop)
	c:RegisterEffect(e2)
	--can not be battle target
		local e31=Effect.CreateEffect(c)
		e31:SetType(EFFECT_TYPE_SINGLE)
		e31:SetCode(EFFECT_IGNORE_BATTLE_TARGET)
		e31:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
		e31:SetRange(LOCATION_MZONE)
		e31:SetValue(1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetTarget(function(e,c) return c:IsType(TYPE_TOKEN) end)
	e3:SetLabelObject(e31)
	c:RegisterEffect(e3)
	--cannot release
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_RELEASE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(0,1)
	e4:SetTarget(aux.TargetBoolFunction(Card.IsType,TYPE_TOKEN))
	c:RegisterEffect(e4)
	--cannot material
		local e51=Effect.CreateEffect(c)
		e51:SetType(EFFECT_TYPE_SINGLE)
		e51:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		e51:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e51:SetValue(1)
	local e5=e3:Clone()
	e5:SetLabelObject(e51)
	c:RegisterEffect(e5) 
		local e61=Effect.CreateEffect(c)
		e61:SetType(EFFECT_TYPE_SINGLE)
		e61:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
		e61:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e61:SetValue(1)
	local e6=e3:Clone()
	e6:SetLabelObject(e61)
	c:RegisterEffect(e6) 
		local e71=Effect.CreateEffect(c)
		e71:SetType(EFFECT_TYPE_SINGLE)
		e71:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
		e71:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e71:SetValue(1)
	local e7=e3:Clone()
	e7:SetLabelObject(e71)
	c:RegisterEffect(e7) 
end
s.setname="WailWitch"


--mat
function s.sumlimit(e,c)
	if not c then return false end
	return not c:IsControler(e:GetHandlerPlayer())
end

--e1
function s.cbfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function s.cbtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cbfilter(chkc,e) end
	local ag=Duel.GetAttacker():GetAttackableTarget()
	local at=Duel.GetAttackTarget()
	ag:RemoveCard(at)
	if chk==0 then return Duel.GetAttacker():IsControler(1-tp) and at:IsControler(tp) and WW_N.ck(at)
		and ag:IsExists(s.cbfilter,1,e:GetHandler(),e) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=ag:FilterSelect(tp,s.cbfilter,1,1,e:GetHandler(),e)
	Duel.SetTargetCard(g)
end
function s.cbop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetAttacker():IsImmuneToEffect(e) then
		Duel.ChangeAttackTarget(tc)
	end
end
function s.cecon(e,tp,eg,ep,ev,re,r,rp)
	if e==re or rp~=1-tp or not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or g:GetCount()~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE) and WW_N.ck(tc)
end
function s.cefilter(c,ct,oc)
	return oc~=c and Duel.CheckChainTarget(ct,c)
end
function s.cetg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.cefilter(chkc,ev,e:GetHandler()) end
	if chk==0 then return Duel.IsExistingTarget(s.cefilter,tp,LOCATION_MZONE,0,1,e:GetLabelObject(),ev,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,s.cefilter,tp,LOCATION_MZONE,0,1,1,e:GetLabelObject(),ev,e:GetHandler())
end
function s.ceop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.ChangeTargetCard(ev,Group.FromCards(tc))
	end
end