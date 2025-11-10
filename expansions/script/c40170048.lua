--元素英雄 救援水手侠
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SSET)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.damcost)
	e1:SetTarget(s.damtg)
	e1:SetOperation(s.damop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_DAMAGE)
	e2:SetCondition(s.effcon)
	e2:SetCost(s.cost)
	e2:SetTarget(s.efftg)
	c:RegisterEffect(e2)
end 
s.material_setcode=0x8
function s.ffilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x3008) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
function s.damcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(1400)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,1400)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
function s.effcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler() 
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if re and re:GetHandler()==c and ep==1-tp and (r&REASON_EFFECT+REASON_BATTLE)~=0 then 
		return true 
	elseif eg and eg:IsContains(c) and ep==1-tp and (r&REASON_EFFECT+REASON_BATTLE)~=0 then
		return true 
	end
	return false
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToExtraAsCost() end
	Duel.SendtoDeck(c,nil,SEQ_DECKTOP,REASON_COST)
end

function s.mgfilter(c,e,tp,fusc,mg)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and c:GetReason()&(REASON_FUSION+REASON_MATERIAL)==(REASON_FUSION+REASON_MATERIAL) and c:GetReasonCard()==fusc
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and fusc:CheckFusionMaterial(mg,c,PLAYER_NONE,true)
end
function s.defustg(e,tp)
	local g=e:GetHandler():GetMaterial()
	local ct=g:GetCount()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	return ct>0 and ft>=ct and not Duel.IsPlayerAffectedByEffect(tp,59822133)
		and e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
		and g:FilterCount(s.mgfilter,nil,e,tp,e:GetHandler(),g)==ct
end
function s.spfilter(c,e,tp)
	return c:IsLevel(7) and c:IsSetCard(0x8) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.sptg(e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if e:GetHandler():GetSequence()<5 then ft=ft+1 end
	return ft>0 and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,nil,e,tp)
end
function s.efftg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=s.defustg(e,tp)
	local b2=s.sptg(e,tp)
	if chk==0 then return b1 or b2 end
	local op=aux.SelectFromOptions(tp,
		{b1,aux.Stringid(id,2)},
		{b2,aux.Stringid(id,3)})
	if op==1 then
		e:SetOperation(s.defusop)
		local g=e:GetHandler():GetMaterial()
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
	else
		e:SetOperation(s.spop)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK)
	end
end
function s.defusop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then return end
	local g=e:GetHandler():GetMaterial()
	local ct=g:GetCount()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>=ct
		and g:FilterCount(s.mgfilter,nil,e,tp,e:GetHandler(),g)==ct then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_HAND|LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
	end
end