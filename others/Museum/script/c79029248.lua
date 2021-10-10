--罗德岛·先锋干员-贾维
function c79029248.initial_effect(c)
	c:EnableReviveLimit()  
	--special summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetValue(SUMMON_TYPE_SYNCHRO)
	e1:SetCondition(c79029248.sprcon)
	e1:SetOperation(c79029248.sprop)
	c:RegisterEffect(e1)
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(TYPE_SYNCHRO+TYPE_EFFECT)
	c:RegisterEffect(e1)  
	--dark Synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetValue(-8)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,79029248)
	e1:SetCondition(c79029248.lzcon)
	e1:SetTarget(c79029248.lztg)
	e1:SetOperation(c79029248.lzop)
	c:RegisterEffect(e1)  
	--Destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029248,0))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(c79029248.decost)
	e2:SetTarget(c79029248.detg)
	e2:SetOperation(c79029248.deop)
	c:RegisterEffect(e2)
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(79029248,5))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetRange(LOCATION_HAND+LOCATION_DECK)
	e2:SetCountLimit(1,7902924)
	e2:SetCondition(c79029248.linkcon)
	e2:SetOperation(c79029248.linkop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND+LOCATION_DECK,0)
	e3:SetTarget(c79029248.mattg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c79029248.cfilter2(c,e,tp,tc)
	return c:IsFaceup() and c:IsType(TYPE_TUNER) 
end
function c79029248.cfilter1(c,e,tp)
	local g=Duel.GetMatchingGroup(c79029248.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=c:GetLevel()
	return c:IsFaceup() and g:CheckWithSumEqual(Card.GetLevel,8+lv,1,99) and not c:IsType(TYPE_TUNER)
end
function c79029248.sprcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c79029248.cfilter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
end
function c79029248.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,c79029248.cfilter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
	local mc=g1:GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.GetMatchingGroup(c79029248.cfilter2,tp,LOCATION_MZONE,0,nil)
	local lv=mc:GetLevel()
	local g2=g:SelectWithSumEqual(tp,Card.GetLevel,8+lv,1,99)
	g1:Merge(g2)
	if Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_SYNCHRO)~=0 then
	e:GetHandler():SetMaterial(g1)
	Debug.Message("嘿，走着！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029248,1))
end
end
function c79029248.lzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType(SUMMON_TYPE_SYNCHRO)
end
function c79029248.spfilter(c,x,e,tp)
	return c:IsLevelBelow(x) and c:IsSetCard(0xa900) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c79029248.lztg(e,tp,eg,ep,ev,re,r,rp,chk)
	local x=e:GetHandler():GetMaterialCount() 
	local sg=Duel.GetMatchingGroup(c79029248.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,x,e,tp)
	if chk==0 then return sg:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,0)
end
function c79029248.lzop(e,tp,eg,ep,ev,re,r,rp)
	Debug.Message("哈哈，让我们干一票大的！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029248,3))
	local x=e:GetHandler():GetMaterialCount() 
	local sg=Duel.GetMatchingGroup(c79029248.spfilter,tp,LOCATION_DECK+LOCATION_HAND+LOCATION_GRAVE,0,nil,x,e,tp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	if sg:GetCount()==0 then return end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tc=sg:Select(tp,1,1,nil):GetFirst()
		sg:RemoveCard(tc)
		x=x-tc:GetLevel()
		Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
		sg:Remove(Card.IsLevelAbove,nil,x+1)
		ft=ft-1
	until ft<=0 or sg:GetCount()==0 or not Duel.SelectYesNo(tp,aux.Stringid(28577986,1))
	Duel.SpecialSummonComplete()
end
function c79029248.cofil(c)
	return c:IsType(TYPE_TOKEN) and c:IsReleasable()
end
function c79029248.decost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029248.cofil,tp,LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029248.cofil,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Release(g,REASON_COST)
end 
function c79029248.detg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,2,nil)
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,nil,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,5,tp,0x1099)
end
function c79029248.deop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	Duel.Destroy(g,REASON_EFFECT)
	e:GetHandler():AddCounter(0x1099,5)
	Debug.Message("好了好了，你们已经很努力了。")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029248,2))
end
function c79029248.linkcon(e,c,tp)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0	
	end
function c79029248.linkop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	Debug.Message("听我说，各位，我有个计划！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029248,4))
end
function c79029248.mattg(e,c)
	return c:IsLevel(1) and (c:IsRace(RACE_CYBERSE) or c:IsRace(RACE_MACHINE))
end