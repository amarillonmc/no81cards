--拟态武装 松彗
function c67200657.initial_effect(c)
	--synchro summon
	--aux.AddSynchroMixProcedure(c,aux.Tuner(nil),nil,nil,aux.FilterBoolFunction(Card.IsSetCard,0x667b),1,99)
	c:EnableReviveLimit()
	--Synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(67200657,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c67200657.syncon)
	e0:SetTarget(c67200657.syntg)
	e0:SetOperation(c67200657.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)   
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(67200657,1))
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c67200657.atkcon1)
	e1:SetTarget(c67200657.atktg1)
	e1:SetOperation(c67200657.atkop1)
	c:RegisterEffect(e1)  
end
function c67200657.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c67200657.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c67200657.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return c67200657.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function c67200657.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsSynchroType(TYPE_LINK) and c:IsSetCard(0x667b) and c:IsControler(tp) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard)
end
function c67200657.matfilter2(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard) and c:IsSetCard(0x667b)
--and c:IsNotTuner(syncard) 
end
function c67200657.val(c,syncard)
	if c:IsSynchroType(TYPE_LINK) then
		return c:GetLink()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function c67200657.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c67200657.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c67200657.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return c67200657.CheckGroup(tsg,c67200657.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function c67200657.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c67200657.val,lv,ct,ct,syncard)
end
function c67200657.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c67200657.matfilter1,nil,c,tp)
		g2=mg:Filter(c67200657.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c67200657.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c67200657.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c67200657.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return c67200657.matfilter1(c,tp) and c67200657.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return c67200657.matfilter1(pe:GetOwner(),tp) and c67200657.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(c67200657.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function c67200657.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c67200657.matfilter1,nil,c,tp)
		g2=mg:Filter(c67200657.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c67200657.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c67200657.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c67200657.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,c67200657.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(m,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=c67200657.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,c67200657.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c67200657.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c67200657.vafilter(c)
	return c:IsSetCard(0x667b)
end
function c67200657.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(c67200657.vafilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
--
function c67200657.atkcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c67200657.atkval(e,c)
	local g=e:GetHandler():GetMaterial()
	local ag=Group.Filter(g,Card.IsType,nil,TYPE_MONSTER)
	local x=0
	local y=0
	local tc=ag:GetFirst()
	while tc do
		y=tc:GetLink()
		x=x+y
		tc=ag:GetNext()
	end
	return x*1000
end
function c67200657.atktg1(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=e:GetHandler():GetMaterial()
	if mg:GetCount()<1 then return false end
	if chk==0 then return mg:IsExists(Card.IsType,1,nil,TYPE_LINK) end
end
function c67200657.atkop1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(c67200657.atkval)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	c:RegisterEffect(e1)
end