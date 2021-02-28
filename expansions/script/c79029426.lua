--萨尔贡·重装干员-森蚺·轻型挂斧
function c79029426.initial_effect(c)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,2) 
	--fusion 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,79029426)
	e1:SetCondition(c79029426.mtcon)
	e1:SetTarget(c79029426.mttg)
	e1:SetOperation(c79029426.mtop)
	c:RegisterEffect(e1)   
	--xyz
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetCountLimit(1,79029426)
	e2:SetCost(c79029426.xyzcost)
	e2:SetTarget(c79029426.xyztg)
	e2:SetOperation(c79029426.xyzop)
	c:RegisterEffect(e2)
end
function c79029426.cfilter(c,lg)
	return c:IsRace(RACE_CYBERSE) and bit.band(c:GetSummonLocation(),LOCATION_EXTRA)~=0 and lg:IsContains(c) and c:IsType(TYPE_FUSION) and c:GetSummonType()==SUMMON_TYPE_FUSION 
end
function c79029426.mtcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup()
	return eg:IsExists(c79029426.cfilter,1,nil,lg)
end
function c79029426.mtfil(c)
	return c:IsAbleToGrave()
end
function c79029426.mttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029426.mtfil,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,1-tp,LOCATION_MZONE)
end
function c79029426.mtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	local g=Duel.GetMatchingGroup(c79029426.mtfil,tp,0,LOCATION_MZONE,nil)
	if g:GetCount()<=0 then return end
	Debug.Message("该狩猎了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029426,2))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoGrave(sg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	local dg=eg:Filter(c79029426.cfilter,nil,lg)
	local tc=dg:GetFirst()
	while tc do
	local mg=tc:GetMaterial()
	sg:Merge(mg)
	tc:SetMaterial(sg)
	tc=dg:GetNext()
	end
	local lg=e:GetHandler():GetLinkedGroup()
	if lg:IsExists(Card.IsSetCard,1,nil,0xa900) and Duel.IsExistingMatchingCard(c79029426.mtfil,tp,0,LOCATION_MZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(79029426,0)) then
	Debug.Message("全部解决掉就好了吗？")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029426,3))
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg1=Duel.SelectMatchingCard(tp,c79029426.mtfil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SendtoGrave(sg1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)  
	local dg=eg:Filter(c79029426.cfilter,nil,lg)
	local tc=dg:GetFirst()
	while tc do
	local mg=tc:GetMaterial()
	sg1:Merge(mg)
	tc:SetMaterial(sg1)
	tc=dg:GetNext()
	end 
	end
end
function c79029426.xyzcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,1000) end
	Duel.PayLPCost(tp,1000)
end
function c79029426.fselect(g,tp)
	return Duel.IsExistingMatchingCard(c79029426.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,g) 
end
function c79029426.xyzfilter(c,g)
	return c:IsRace(RACE_CYBERSE) and c:IsXyzSummonable(g,2,2)
end
function c79029426.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lg=c:GetLinkedGroup()
	if chk==0 then return lg:CheckSubGroup(c79029426.fselect,2,2,tp,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c79029426.xyzop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("有人配合会更有效率。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029426,4))
	local c=e:GetHandler()
	local lg=e:GetHandler():GetLinkedGroup()
	local xyzg=Duel.GetMatchingGroup(c79029426.xyzfilter,tp,LOCATION_EXTRA,0,nil,lg)
	if xyzg:GetCount()>0 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
	Duel.Overlay(xyz,lg)
	xyz:SetMaterial(lg)
	Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
	if xyz:IsSetCard(0xa900) then
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(xyz:GetAttack()*2)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	xyz:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	e2:SetValue(xyz:GetDefense()*2)
	xyz:RegisterEffect(e2)
	end
	Duel.SpecialSummonComplete()
	xyz:CompleteProcedure()
	Duel.BreakEffect()
	if Duel.SelectYesNo(tp,aux.Stringid(79029426,1)) then
	Debug.Message("我随时都可以。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029426,5))
	Duel.Overlay(xyz,e:GetHandler())
	end
	end
end







