--芙蓉·0011™制造收藏-守岁人
function c79029306.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	--splimit
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_PZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c79029306.splimit1)
	c:RegisterEffect(e2)  
	--add code
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_ADD_CODE)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetValue(79029152)
	c:RegisterEffect(e2)   
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c79029306.spcon)
	e1:SetTarget(c79029306.sptg)
	e1:SetCountLimit(1,79029306)
	e1:SetOperation(c79029306.spop)
	c:RegisterEffect(e1)  
	--
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCost(c79029306.pcost)
	e3:SetTarget(c79029306.ptg)
	e3:SetOperation(c79029306.pop)
	c:RegisterEffect(e3)
	--synchro custom
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetTarget(c79029306.syntg)
	e1:SetValue(1)
	e1:SetOperation(c79029306.synop)
	c:RegisterEffect(e1)  
end
function c79029306.splimit1(e,c,tp,sumtp,sumpos)
	return not c:IsSetCard(0xa900) and bit.band(sumtp,SUMMON_TYPE_PENDULUM)==SUMMON_TYPE_PENDULUM
end
function c79029306.fselect(g,tp)
	return Duel.GetMZoneCount(tp,g)>0
end
function c79029306.sprfilter(c)
	return c:IsSetCard(0xa900) and c:IsAbleToHandAsCost()
end
function c79029306.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c79029306.sprfilter,tp,LOCATION_PZONE,0,nil)
	return g:CheckSubGroup(c79029306.fselect,1,1,tp)
end
function c79029306.sptg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(c79029306.sprfilter,tp,LOCATION_PZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local sg=g:SelectSubGroup(tp,c79029306.fselect,true,1,1,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function c79029306.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoHand(g,tp,REASON_COST)
	Debug.Message("准备治疗！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029306,0))
	g:DeleteGroup()
end
function c79029306.pcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c79029306.pfil(c)
	return c:IsFaceup() and c:IsSetCard(0xa900) and c:IsType(TYPE_PENDULUM) and not c:IsCode(79029306)
end
function c79029306.ptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029306.pfil,tp,LOCATION_EXTRA,0,1,nil) end
	Debug.Message("这里很安全！")
	Duel.Hint(HINT_SOUND,0,aux.Stringid(79029306,1))
	local g=Duel.SelectMatchingCard(tp,c79029306.pfil,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.SetTargetCard(g)
end  
function c79029306.pop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	Duel.MoveToField(tc,tp,tp,LOCATION_PZONE,POS_FACEUP,true)
end
function c79029306.synfilter(c,syncard,tuner,f)
	return (c:IsFaceup() or c:IsLocation(LOCATION_HAND+LOCATION_PZONE)) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c79029306.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c79029306.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c79029306.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c79029306.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
		and g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_PZONE)<=1
end
function c79029306.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c79029306.synfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f)
	return mg:IsExists(c79029306.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c79029306.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+99
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c79029306.synfilter,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_PZONE,LOCATION_MZONE,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(c79029306.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c79029306.syngoal(g,tp,lv,syncard,minc,i) then
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









