--星辉之涅槃女神
function c9910630.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddFusionProcFunRep(c,c9910630.ffilter,3,true)
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.fuslimit)
	c:RegisterEffect(e1)
	--special summon rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(c9910630.sprcon)
	e2:SetOperation(c9910630.sprop)
	c:RegisterEffect(e2)
	--pendulum set
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetTarget(c9910630.settg)
	e3:SetOperation(c9910630.setop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_PZONE)
	e4:SetCountLimit(1,9910631)
	e4:SetCost(c9910630.rcost)
	e4:SetTarget(c9910630.rtg)
	e4:SetOperation(c9910630.rop)
	c:RegisterEffect(e4)
	if not c9910630.global_check then
		c9910630.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c9910630.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c9910630.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or (sg:IsExists(Card.IsFusionAttribute,1,c,c:GetFusionAttribute())
			and not sg:IsExists(Card.IsRace,1,c,c:GetRace()))
end
function c9910630.checkop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsActiveType(TYPE_MONSTER) then return end
	local race=re:GetHandler():GetOriginalRace()
	local labels={Duel.GetFlagEffectLabel(tp,9910631)}
	local flag=0
	for i=1,#labels do flag=bit.bor(flag,labels[i]) end
	if bit.band(flag,race)==0 then
		Duel.RegisterFlagEffect(tp,9910630,RESET_PHASE+PHASE_END,0,1)
	end
	Duel.RegisterFlagEffect(tp,9910631,RESET_PHASE+PHASE_END,0,1,race)
end
function c9910630.sprfilter1(c,sc)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToRemoveAsCost() and c:IsCanBeFusionMaterial(sc,SUMMON_TYPE_SPECIAL)
end
function c9910630.sprfilter2(g,tp,sc)
	return Duel.GetLocationCountFromEx(tp,tp,g,sc)>0 and g:GetClassCount(Card.GetRace)==3
		and g:GetClassCount(Card.GetAttribute)==1
end
function c9910630.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c9910630.sprfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	return Duel.GetFlagEffect(tp,9910630)>=3 and g:CheckSubGroup(c9910630.sprfilter2,3,3,tp,c)
end
function c9910630.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c9910630.sprfilter1,tp,LOCATION_HAND+LOCATION_MZONE,0,nil,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local sg=g:SelectSubGroup(tp,c9910630.sprfilter2,false,3,3,tp,c)
	c:SetMaterial(sg)
	Duel.Remove(sg,POS_FACEUP,REASON_COST)
end
function c9910630.setfilter(c)
	return c:IsType(TYPE_PENDULUM) and not c:IsForbidden()
		and (c:IsLocation(LOCATION_DECK) or c:IsFaceup())
end
function c9910630.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
		and Duel.IsExistingMatchingCard(c9910630.setfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,nil) end
end
function c9910630.setop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local g=Duel.SelectMatchingCard(tp,c9910630.setfilter,tp,LOCATION_DECK+LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_PZONE,POS_FACEUP,true)
	end
end
function c9910630.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c9910630.spfilter(c,e,tp,mc)
	return bit.band(c:GetOriginalType(),0x81)==0x81 and (not c.mat_filter or c.mat_filter(mc,tp)) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true)
end
function c9910630.rfilter2(c,lv,n)
	if not n then n=0 end
	return lv-n>=c:GetLevel()
end
function c9910630.filter(c,e,tp)
	local sg=Duel.GetMatchingGroup(c9910630.spfilter,tp,LOCATION_HAND,0,c,e,tp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local lv=0
	if c:GetLevel()>0 then lv=c:GetLevel()
	elseif c:GetRank()>0 then lv=c:GetRank() end
	return sg:IsExists(Card.IsLevelBelow,1,nil,lv)
end
function c9910630.mfilter(c)
	return (c:GetLevel()>0 or c:GetRank()>0) and c:IsAbleToRemove()
end
function c9910630.rtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if ft<0 then return false end
		local mg=Duel.GetMatchingGroup(c9910630.mfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
		return mg:IsExists(c9910630.filter,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c9910630.rop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<0 then return end
	local mg=Duel.GetMatchingGroup(c9910630.mfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local mat=mg:FilterSelect(tp,c9910630.filter,1,1,nil,e,tp)
	local mc=mat:GetFirst()
	if not mc then return end
	local sg=Duel.GetMatchingGroup(c9910630.spfilter,tp,LOCATION_HAND,0,mc,e,tp,mc)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local lv=0
	if mc:GetLevel()>0 then lv=mc:GetLevel()
	elseif mc:GetRank()>0 then lv=mc:GetRank() end
	if not sg:IsExists(Card.IsLevelBelow,1,nil,lv) then return end
	local tg=Group.CreateGroup()
	local n=0
	while n<lv and tg:GetCount()<ft and (n==0 or sg:IsExists(c9910630.rfilter2,1,nil,lv,n) and Duel.SelectYesNo(tp,210)) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local rc=sg:FilterSelect(tp,c9910630.rfilter2,1,1,nil,lv,n):GetFirst()
		tg:AddCard(rc)
		n=n+rc:GetLevel()
		sg:RemoveCard(rc)
	end
	for tc in aux.Next(tg) do
		tc:SetMaterial(mat)
	end
	Duel.Remove(mat,POS_FACEUP,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
	Duel.BreakEffect()
	for tc in aux.Next(tg) do
		Duel.SpecialSummonStep(tc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		tc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
