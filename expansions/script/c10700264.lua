--寂日谈 失去目标
function c10700264.initial_effect(c)
	--spsummon limit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c10700264.splimit)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10700264,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCountLimit(1,10700264)
	e1:SetCondition(c10700264.spcon)
	e1:SetTarget(c10700264.sptg)
	e1:SetOperation(c10700264.spop)
	c:RegisterEffect(e1)  
	--XyzSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,10700264+100)
	e2:SetTarget(c10700264.xyztg)
	e2:SetOperation(c10700264.xyzop)
	c:RegisterEffect(e2)
end
function c10700264.splimit(e,se,sp,st)
	return se:GetHandler():IsSetCard(0xb02)
end
function c10700264.cfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_MONSTER) 
end
function c10700264.lv_or_rk(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	else return c:GetLevel() end
end
function c10700264.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local sum=Duel.GetMatchingGroup(c10700264.cfilter,tp,LOCATION_MZONE,0,nil):GetSum(c10700264.lv_or_rk)
	if sum<4 then return false end
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>0
end
function c10700264.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c10700264.dfilter(c)
	return c:IsFaceup() and not c:IsRace(RACE_MACHINE)
end
function c10700264.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local dg=Duel.GetMatchingGroup(c10700264.dfilter,tp,LOCATION_MZONE,0,nil)
	if c:IsRelateToEffect(e) and Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
	   Duel.BreakEffect()
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c10700264.xyzfilter(c,mg,e,tp)
   return c:GetRank()<=(mg:GetSum(Card.GetLevel)+mg:GetSum(Card.GetRank)) and mg:Filter(Card.IsCanBeXyzMaterial,nil,c):GetCount()==mg:GetCount() and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false,POS_FACEUP) and c:IsType(TYPE_XYZ)
end
function c10700264.spfilter(c,e,tp,mc)
	local mg=Group.CreateGroup()
	mg:AddCard(c)
	mg:AddCard(mc)
	return Duel.IsExistingMatchingCard(c10700264.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,mg,e,tp) and Duel.GetLocationCountFromEx(tp,tp,mg,TYPE_XYZ)>0 
end
function c10700264.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=e:GetHandler():GetOwner()
	if chk==0 then return Duel.IsExistingTarget(c10700264.spfilter,tp,LOCATION_MZONE,0,1,e:GetHandler(),e,tp,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,c10700264.spfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler(),e,tp,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c10700264.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local tg=tc:GetOverlayGroup()
	local flag=0
	if tg then flag=1 end
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		local mg=Group.CreateGroup()
		mg:AddCard(c)
		mg:AddCard(tc)
		mg:KeepAlive()
		local hg=Duel.GetMatchingGroup(c10700264.xyzfilter,tp,LOCATION_EXTRA,0,nil,mg,e,tp)
		if hg:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=hg:Select(tp,1,1,nil)
			local sc=sg:GetFirst()
			 Duel.SendtoGrave(tg,REASON_RULE)
			local e2=Effect.CreateEffect(sc)
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_SPSUMMON_PROC)
			e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
			e2:SetRange(LOCATION_EXTRA)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			e2:SetValue(SUMMON_TYPE_XYZ)
			e2:SetLabelObject(mg)
			e2:SetOperation(c10700264.sprop)
			sc:RegisterEffect(e2)
			Duel.XyzSummon(tp,sc,mg)
		end
	end
end
function c10700264.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=e:GetLabelObject()
	Duel.Overlay(c,mg)
end