--炽金战兽 奈普顿
local m=82209169
local cm=c82209169
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkSetCard,0x5294),2,2)  
	--common draw effect  
	local e0=Effect.CreateEffect(c)  
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetCategory(CATEGORY_DRAW)  
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)  
	e0:SetCode(EVENT_TO_GRAVE)  
	e0:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)  
	e0:SetCondition(cm.cmcon)  
	e0:SetTarget(cm.cmtg)  
	e0:SetOperation(cm.cmop)  
	c:RegisterEffect(e0)
	--spsummon  
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,1))  
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)  
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1,m)  
	e1:SetCondition(cm.spcon)
	e1:SetTarget(cm.sptg)  
	e1:SetOperation(cm.spop)  
	c:RegisterEffect(e1) 
	--damage
	local e2=Effect.CreateEffect(c)  
	e2:SetDescription(aux.Stringid(m,2))  
	e2:SetCategory(CATEGORY_DAMAGE)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e2:SetCode(EVENT_BATTLED)  
	e2:SetCountLimit(1,m+10000)
	e2:SetTarget(cm.damtg)  
	e2:SetOperation(cm.damop)  
	c:RegisterEffect(e2) 
end

--common draw effect
function cm.cmcon(e,tp,eg,ep,ev,re,r,rp)  
	local c=e:GetHandler() 
	return c:IsPreviousLocation(LOCATION_ONFIELD) 
			and rp==1-tp and c:GetPreviousControler()==tp
end  
function cm.cmtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)  
end
function cm.cmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoDeck(c,nil,2,REASON_EFFECT) 
		if c:IsLocation(LOCATION_EXTRA) then
			Duel.Draw(tp,1,REASON_EFFECT)
		end
	end
end

--spsummon
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.spfilter(c,e,tp)  
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)  
end  
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0  
		and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)  
end  
function cm.spop(e,tp,eg,ep,ev,re,r,rp)  
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end  
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
	local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)  
	if g:GetCount()>0 then  
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)  
	end  
end  

--damage
function cm.damfilter(c)  
	return c:IsFaceup() and c:GetAttack()>0  
end  
function cm.damtg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.IsExistingMatchingCard(cm.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end  
	local g=Duel.GetMatchingGroup(cm.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)  
	local tg,dam=g:GetMaxGroup(Card.GetAttack) 
	Duel.SetTargetPlayer(1-tp)  
	Duel.SetTargetParam(dam)  
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)  
end  
function cm.damop(e,tp,eg,ep,ev,re,r,rp)  
	local g=Duel.GetMatchingGroup(cm.damfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	if g:GetCount()>0 then
		local tg,dam=g:GetMaxGroup(Card.GetAttack) 
		if dam>0 then
			local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
			Duel.Damage(p,dam,REASON_EFFECT)  
		end
	end  
end  