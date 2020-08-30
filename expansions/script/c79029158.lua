--罗德岛·重装干员-斑点
function c79029158.initial_effect(c)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c79029158.syntg)
	e1:SetValue(1)
	e1:SetOperation(c79029158.synop)
	c:RegisterEffect(e1)   
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(2688979029158,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_REMOVE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,79029158)
	e2:SetCondition(c79029158.spcon)
	e2:SetTarget(c79029158.sptg)
	e2:SetOperation(c79029158.spop)
	c:RegisterEffect(e2)  
end
function c79029158.synfilter(c,syncard,tuner,f)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_PZONE)) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c79029158.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c79029158.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c79029158.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c79029158.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_PZONE)<=1
end
function c79029158.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c79029158.synfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f)
	return mg:IsExists(c79029158.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c79029158.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+99
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c79029158.synfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(c79029158.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c79029158.syngoal(g,tp,lv,syncard,minc,i) then
			if not Duel.SelectYesNo(tp,79029210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end
function c79029158.cfilter(c,tp)
	return c:IsSetCard(0xa900) and c:IsType(TYPE_MONSTER) and not c:IsCode(79029158) and c:IsControler(tp)
end
function c79029158.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c79029158.cfilter,1,nil,tp)
end
function c79029158.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c79029158.spop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("挺好的。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029158,0))
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end