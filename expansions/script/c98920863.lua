--雷天龙-雷龙
--雷天源龙-雷龙
local s,id,o=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode2(c,5206415,20318029,false,false)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(aux.fuslimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(s.thcost)
	e2:SetTarget(s.thtg)
	e2:SetOperation(s.thop)
	c:RegisterEffect(e2)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetCost(s.spcost)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
	--global check for thunder monster effect from hand
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsRace(RACE_THUNDER)
		and re:GetHandler():IsPreviousLocation(LOCATION_HAND) then
		Duel.RegisterFlagEffect(rp,id,RESET_PHASE+PHASE_END,0,1)
	end
end
-- 自身特召规则
function s.spfilter1(c)
	return c:IsRace(RACE_THUNDER) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or (c:IsLocation(LOCATION_MZONE) and c:IsFaceup()))
end
function s.spfilter2(c)
	return c:IsCode(20318029) and c:IsAbleToRemoveAsCost() and (c:IsLocation(LOCATION_HAND) or c:IsLocation(LOCATION_GRAVE) or c:IsLocation(LOCATION_DECK))
end
function s.rescon(sg,e,tp,mg)
	return sg:FilterCount(s.spfilter1,nil)==1 and sg:FilterCount(s.spfilter2,nil)==1
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	if Duel.GetFlagEffect(tp,id)==0 then return false end
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	return Duel.GetLocationCountFromEx(tp,tp,g1,c)>0 and g1:GetCount()>0 and g2:GetCount()>0
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.GetMatchingGroup(s.spfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(s.spfilter2,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg1=g1:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg2=g2:Select(tp,1,1,nil)
	sg1:Merge(sg2)
	if sg1 then
		sg1:KeepAlive()
		e:SetLabelObject(sg1)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local sg=e:GetLabelObject()
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
	sg:DeleteGroup()
end
-- ①效果：丢1手，回收除外的2张雷龙怪兽
function s.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD,nil)
end
function s.thfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x11c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil)
	if chk==0 then return g:GetClassCount(Card.GetCode)>=2 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,tp,LOCATION_REMOVED)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(s.thfilter,tp,LOCATION_REMOVED,0,nil)
	if g:GetClassCount(Card.GetCode)>=2 then
		local sg=g:SelectSubGroup(tp,aux.dncheck,false,2,2)
		if sg and #sg==2 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	end
end
-- ②效果：准备阶段解放特召融合怪兽
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function s.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function s.spfilter3(c,e,tp)
	return c:IsRace(RACE_THUNDER) and c:IsType(TYPE_FUSION) and c:IsLevelAbove(7) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,e:GetHandler())>0
		and Duel.IsExistingMatchingCard(s.spfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
			g:GetFirst():CompleteProcedure()
		end
	end
end
