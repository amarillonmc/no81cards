--元素英雄 凤凰火焰翼人
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	aux.AddFusionProcFunRep(c,s.fmfilter,2,true)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,id)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--battle
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	--damage
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(id,1))
	e4:SetCategory(CATEGORY_DAMAGE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_BATTLE_DESTROYING)
	e4:SetCondition(aux.bdcon)
	e4:SetTarget(s.damtg)
	e4:SetOperation(s.damop)
	c:RegisterEffect(e4)
	--special summon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,2))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,id+10000)
	e5:SetCost(s.spcost)
	e5:SetTarget(s.sptg)
	e5:SetOperation(s.spop)
	c:RegisterEffect(e5)
	--material check
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(EFFECT_MATERIAL_CHECK)
	e6:SetValue(s.valcheck)
	c:RegisterEffect(e6)
end
--fusion material
function s.fmfilter(c,fc,sub,mg,sg)
	return c:IsFusionSetCard(0x8) and (not sg or not sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute()))
end
--to hand
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.CreateToken(tp,211000011)
	local g=Group.FromCards(g1)
	Duel.SendtoHand(g,tp,REASON_EFFECT)
end
--damage
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local dam=e:GetHandler():GetBattleTarget():GetBaseAttack()
	if dam<0 then dam=0 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(dam)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,dam)
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Damage(p,d,REASON_EFFECT)
end
--special summon
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReleasable() and c:GetFlagEffect(id)>0 end
	Duel.Release(c,REASON_COST)
end
function s.spfilter(c,e,tp,rc)
	return c:IsSetCard(0x3008) and c:IsLevelBelow(7) and not c:IsSummonableCard() and c:IsCanBeSpecialSummoned(e,0,tp,true,false)
		and (c:IsLocation(LOCATION_DECK) and Duel.GetMZoneCount(tp,rc)>0
			or c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,rc,c)>0)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,1,nil,e,tp,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA+LOCATION_DECK)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.spfilter,tp,LOCATION_EXTRA+LOCATION_DECK,0,nil,e,tp,e:GetHandler())
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
	end
end
--material check
function s.valcheck(e,c)
	local mg=c:GetMaterial()
	if mg:IsExists(Card.IsType,1,nil,TYPE_NORMAL) then
		c:RegisterFlagEffect(id,RESET_EVENT+0x4fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(id,2))
	end
end