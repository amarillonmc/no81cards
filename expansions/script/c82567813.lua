--二次呼吸
function c82567813.initial_effect(c)
	aux.AddRitualProcEqual2(c,c82567813.spfilter5,aux.Stringid(82567813,4))
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(82567813,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,82567813)
	e1:SetCost(c82567813.spcost)
	e1:SetTarget(c82567813.sptg)
	e1:SetOperation(c82567813.spop)
	c:RegisterEffect(e1)
	--XYZActivate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(82567813,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,82567813)
	e2:SetCost(c82567813.spcost2)
	e2:SetTarget(c82567813.sptg2)
	e2:SetOperation(c82567813.spop2)
	c:RegisterEffect(e2)
	--LINKActivate
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(82567813,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_ACTIVATE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCountLimit(1,82567813)
	e3:SetCost(c82567813.spcost3)
	e3:SetTarget(c82567813.sptg3)
	e3:SetOperation(c82567813.spop3)
	c:RegisterEffect(e3)
	--PendulumActivate
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(82567813,3))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_ACTIVATE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,82567813)
	e4:SetCost(c82567813.spcost4)
	e4:SetTarget(c82567813.sptg4)
	e4:SetOperation(c82567813.spop4)
	c:RegisterEffect(e4)
	--RitualActivate
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(82567813,4))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_ACTIVATE)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetCountLimit(1,82567813)
	e5:SetCost(c82567813.spcost5)
	e5:SetTarget(c82567813.sptg5)
	e5:SetOperation(c82567813.spop5)
	c:RegisterEffect(e5)
	--XyzPENActivate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(82567813,5))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_ACTIVATE)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetCountLimit(1,82567813)
	e6:SetCost(c82567813.spcost6)
	e6:SetTarget(c82567813.sptg6)
	e6:SetOperation(c82567813.spop6)
	c:RegisterEffect(e6)
end
function c82567813.rfilter(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return lv>0 and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c82567813.spfilter(c,e,tp,lv)
	return (c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0 and c:IsLevel(lv) and c:IsSetCard(0x825)  and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not (c:IsType(TYPE_PENDULUM)  and c:IsFaceup())) or (c:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and not c:IsType(TYPE_RITUAL) and not c:IsType(TYPE_SPSUMMON) and c:IsLevel(lv) and c:IsSetCard(0x825))
end
function c82567813.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter,1,nil,e,tp,ft) and Duel.IsPlayerCanSpecialSummonCount(tp,1) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalLevel())
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c82567813.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567813.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if tc:IsLocation(LOCATION_DECK) and Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	if tc:IsType(TYPE_FUSION) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) 
	else if tc:IsType(TYPE_SYNCHRO) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP) 
	else if not tc:IsType(TYPE_FUSION) and not tc:IsType(TYPE_SYNCHRO) then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	end 
	end
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
end
function c82567813.rfilter2(c,e,tp,ft)
	local rk=c:GetOriginalRank()
	return rk>0 and c:IsType(TYPE_XYZ) and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,rk)
end
function c82567813.spfilter2(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x825) and c:IsType(TYPE_XYZ) and not c:IsFaceup() and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82567813.spcost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter2,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter2,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalRank())
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c82567813.spop2(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567813.spfilter2,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local c=e:GetHandler() if  c:IsRelateToEffect(e) then
	c:CancelToGrave()
	Duel.Overlay(tc,Group.FromCards(c))
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
end
end
function c82567813.rfilter3(c,e,tp,ft)
	local lm=c:GetLink()
		   
	return lm>0 and c:IsType(TYPE_LINK) and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,lm,c)
end
function c82567813.spfilter3(c,e,tp,lm)
	return c:IsLink(lm) and c:IsSetCard(0x825) and c:IsType(TYPE_LINK) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82567813.spcost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter3,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter3,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	e:SetLabel(tc:GetLink())
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_EXTRA)
end
function c82567813.spop3(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lm=e:GetLabel()
	local rc=e:GetLabelObject()
	if Duel.GetLocationCountFromEx(tp,tp,mc,c)>0
	then Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567813.spfilter3,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e,tp,lm)
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
end
end
function c82567813.rfilter4(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return lv>0 and not c:IsType(TYPE_XYZ) and not c:IsType(TYPE_LINK) and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter4,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
end
function c82567813.spfilter4(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsSetCard(0x825) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82567813.spcost4(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter4,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter4,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetLevel())
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg4(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567813.spop4(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local lv=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567813.spfilter4,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
end
function c82567813.rfilter5(c,e,tp,ft)
	local lv=c:GetOriginalLevel()
	return lv>0 and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter5,tp,LOCATION_DECK,0,1,nil,e,tp,lv)
end
function c82567813.spfilter5(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsSetCard(0x825)  and c:IsType(TYPE_RITUAL) and c:IsCanBeSpecialSummoned(e,0,tp,true,true)
end
function c82567813.spcost5(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter5,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter5,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetOriginalLevel())
end
function c82567813.sptg5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c82567813.spop5(e,tp,eg,ep,ev,re,r,rp,ft,lv)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local lv=e:GetLabel()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local mg=Duel.GetMatchingGroup(c82567813.rfilter5,tp,LOCATION_MZONE,0,nil,e,tp,ft)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tg=Duel.SelectMatchingCard(tp,c82567813.spfilter5,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if tg:GetCount()>0 then
		local tc=tg:GetFirst()
		if tc.mat_filter then
			mg=mg:Filter(tc.mat_filter,nil,tp)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local mat=mg:SelectWithSumEqual(tp,Card.GetRitualLevel,tc:GetLevel(),1,1,tc)
		tc:SetMaterial(mat)
		Duel.Release(mat,REASON_EFFECT+REASON_MATERIAL+REASON_RITUAL)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	   local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
	end
end
function c82567813.rfilter6(c,e,tp,ft)
	local rk=c:GetOriginalRank()
	return rk>0 and c:IsType(TYPE_XYZ) and c:IsSetCard(0x825) and c:IsReleasable()
		and (ft>0 or (c:IsControler(tp) and c:GetSequence()<5)) and (c:IsControler(tp) or c:IsFaceup())
		and Duel.IsExistingMatchingCard(c82567813.spfilter6,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,rk)
end
function c82567813.spfilter6(c,e,tp,rk)
	return c:IsRank(rk) and c:IsSetCard(0x825) and c:IsType(TYPE_PENDULUM) and c:IsFaceup() and c:IsLocation(LOCATION_EXTRA) and c:IsCanBeSpecialSummoned(e,0,tp,true,true) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c82567813.spcost6(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c82567813.rfilter6,1,nil,e,tp,ft) end
	local g=Duel.SelectReleaseGroup(tp,c82567813.rfilter6,1,1,nil,e,tp,ft)
	local tc=g:GetFirst()
	e:SetLabel(tc:GetRank())
	Duel.Release(g,REASON_COST)
end
function c82567813.sptg6(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c82567813.spop6(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local rk=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c82567813.spfilter6,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,rk)
	local tc=g:GetFirst()
	if Duel.GetLocationCountFromEx(tp,tp,nil,tc)<=0 then return end
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,true,true,POS_FACEUP)
	end
	local c=e:GetHandler() if  c:IsRelateToEffect(e) then
	c:CancelToGrave()
	Duel.Overlay(tc,Group.FromCards(c))
	local dmg = tc:GetAttack()/2
	Duel.Damage(tp,dmg,REASON_EFFECT)
end
end