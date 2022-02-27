--珊海环王 高特里奥
function c67200531.initial_effect(c)
	--link summon
	--aux.AddLinkProcedure(c,c67200531.lfilter,6,6,c67200531.lcheck)
	c:EnableReviveLimit()  
	--summon word
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(c67200531.txtcon)
	e0:SetOperation(c67200531.txtop)
	c:RegisterEffect(e0)  
	--extra link
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c67200531.lkcon)
	e1:SetOperation(c67200531.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)   
	--immune
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c67200531.imcon)
	e2:SetValue(c67200531.efilter)
	c:RegisterEffect(e2)
	--change effect type
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(67200531)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	c:RegisterEffect(e6)
end
--
--summon TXT
function c67200531.txtcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsSummonType(SUMMON_TYPE_LINK)
end
function c67200531.txtop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(24,0,aux.Stringid(67200531,7))
	Duel.Hint(24,0,aux.Stringid(67200531,8))
end
--link summon
function c67200531.lkfilter(c,lc,tp)
	local flag=c:IsFaceup() and c:IsCanBeLinkMaterial(lc)
	if c:IsType(TYPE_MONSTER) then
		return flag
	else
		return c:IsFaceup() and c:IsType(TYPE_SPELL) and c:IsType(TYPE_EQUIP) and c:IsSetCard(0x675)
	end
end
function c67200531.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1
	end
end
function c67200531.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c67200531.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c67200531.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c67200531.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c67200531.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c67200531.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c67200531.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=5
	local maxc=6
	if ct>maxc then return false end
	return c67200531.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c67200531.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function c67200531.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c67200531.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=5
	local maxc=6
	for i=ct,maxc-1 do
		local cg=mg:Filter(c67200531.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c67200531.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--
function c67200531.imcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c67200531.efilter(e,te)
	return te:GetOwner()~=e:GetOwner()
end



