--波纹战士 真红之利普
function c65010201.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e1)
	--summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(65010201,2))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetRange(LOCATION_HAND)
	e2:SetTarget(c65010201.target)
	e2:SetOperation(c65010201.operation)
	c:RegisterEffect(e2)
	--splimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(1,0)
	e3:SetTarget(c65010201.splimit)
	c:RegisterEffect(e3)  
	--tog
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(65010201,3))
	e4:SetCategory(CATEGORY_TOGRAVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(c65010201.tgtg)
	e4:SetOperation(c65010201.tgop)
	c:RegisterEffect(e4)  
end
function c65010201.splimit(e,c,sump,sumtp,sumpos,targetp)
	return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c65010201.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(c65010201.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,g:GetCount(),0,0)
end
function c65010201.tgfilter(c,tp)
	return c:GetSequence()<5
end
function c65010201.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c65010201.tgfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	if g:GetCount()>0 then
	   Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c65010201.cfilter(c,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:GetSequence()<5
end
function c65010201.check(c,e,p)
	local g=Duel.GetMatchingGroup(nil,0,LOCATION_MZONE,LOCATION_MZONE,nil)
	local ap={}
	ap[0]=false
	ap[1]=false
	for tc in aux.Next(g) do
		local g=Group.CreateGroup()
		local tp=tc:GetControler()
		if tc:GetSequence()<5 then
		   local sg=tc:GetColumnGroup(1,1):Filter(c65010201.cfilter,nil,tp)
		   g:AddCard(tc)
		   g:Merge(sg)
		end
		if tc:GetSequence()>4 then
		   local sc=tc:GetColumnGroup():Filter(c65010201.cfilter,nil,tp):GetFirst()
		   if sc then
			  local sg=sc:GetColumnGroup(1,1):Filter(c65010201.cfilter,nil,tp)
			  g:AddCard(tc)
			  g:AddCard(sc)
			  g:Merge(sg)
		   end
		end
		if g:GetCount()>=3 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,p,true,false,POS_FACEUP,tp) then ap[tp]=true 
		end
	end
	return ap
end
function c65010201.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ap=c65010201.check(e:GetHandler(),e,tp)
	if chk==0 then return not e:GetHandler():IsStatus(STATUS_CHAINING) and (ap[0] or ap[1]) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65010201.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local ap=c65010201.check(c,e,tp)
	if not ap[0] and not ap[1] then return end
	local sp=0
	if ap[0] and ap[1] then
	   local ct=Duel.SelectOption(tp,aux.Stringid(65010201,0),aux.Stringid(65010201,1))
	   if ct==0 then sp=tp 
	   else sp=1-tp
	   end
	elseif ap[1] then sp=1 
	end 
	Duel.SpecialSummon(c,0,tp,sp,true,false,POS_FACEUP)
end