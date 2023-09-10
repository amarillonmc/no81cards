--科技属 武装蛛蟹
function c98920495.initial_effect(c)
	 c:SetSPSummonOnce(98920495)
	--link summon
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c98920495.matfilter,1,1)
	--Synchro summon   
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98920495,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98920495.syncon)
	e0:SetTarget(c98920495.syntg)
	e0:SetOperation(c98920495.SynOperation(f1,f2,minc,maxc))
	e0:SetValue(SUMMON_TYPE_SYNCHRO) 
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_EXTRA,0)
	e3:SetTarget(c98920495.eftg)
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)
	--spsummon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(98920495,0))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,98920495)
	e4:SetCost(c98920495.spcost)
	e4:SetTarget(c98920495.sptg)
	e4:SetOperation(c98920495.spop)
	c:RegisterEffect(e4)
	--syr grave
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(c98920495.reccon)
	e5:SetOperation(c98920495.recop)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e6)
	local e7=e5:Clone()
	e7:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_TO_GRAVE)
	e8:SetOperation(c98920495.recop)
	c:RegisterEffect(e8)
	local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(98920495,1))
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e9:SetCode(EVENT_SPSUMMON)
	e9:SetRange(LOCATION_GRAVE)
	e9:SetCondition(c98920495.setcon)
	e9:SetOperation(c98920495.setop)
	c:RegisterEffect(e9)
	if not c98920495.global_check then
		c98920495.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
		ge1:SetCode(EFFECT_MATERIAL_CHECK)
		ge1:SetValue(c98920495.valcheck)
		Duel.RegisterEffect(ge1,0)
	end
end
function c98920495.valcheck(e,c)
	local g=c:GetMaterial()
	local tp=c:GetOwner()
	if g:IsExists(Card.IsControler,1,nil,1-tp) then
		c:RegisterFlagEffect(98920495,RESET_EVENT+0x4fe0000,0,1)
	end
end
function c98920495.setfilter(c,tp)
	return c:IsFaceup() and c:IsControler(tp) and c:IsSummonType(SUMMON_TYPE_SYNCHRO) and c:GetFlagEffect(98920495)~=0
end
function c98920495.setcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920495.setfilter,1,nil,tp)
end
function c98920495.matval(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
function c98920495.mfilter(c)
	return c:IsType(TYPE_MONSTER)
end   
function c98920495.matfilter(c)
	return c:IsType(TYPE_SYNCHRO)
end
function c98920495.eftg1(e,c)
	return c:IsCode(98558751,99937842)
end
function c98920495.eftg(e,c)
	return c:IsSetCard(0x27) and c:IsType(TYPE_SYNCHRO)
end
function c98920495.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c98920495.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c98920495.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return c98920495.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function c98920495.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end 
	if c:IsSynchroType(TYPE_LINK) and c:IsCode(98920495) and c:IsControler(tp) then return true end 
	return c:IsSynchroType(TYPE_TUNER) --and c:IsCanBeSynchroMaterial(syncard)
end
function c98920495.matfilter2(c,syncard,tp)
	if not Duel.IsExistingMatchingCard(c98920495.rmfilter,tp,LOCATION_GRAVE,0,1,nil) and c:IsControler(1-tp) then return false end
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard)
end
function c98920495.val(c,syncard)
	if c:IsCode(98920495) then
		return 1
	else
		return c:GetSynchroLevel(syncard)
	end
end
function c98920495.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c98920495.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c98920495.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return c98920495.CheckGroup(tsg,c98920495.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function c98920495.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c98920495.val,lv,ct,ct,syncard)
end
function c98920495.matval(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
function c98920495.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()   
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c98920495.matfilter1,nil,c,tp)
		g2=mg:Filter(c98920495.matfilter2,nil,c,tp)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c98920495.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
		g2=Duel.GetMatchingGroup(c98920495.matfilter2,tp,LOCATION_MZONE,0,nil,c,tp)
		g3=Duel.GetMatchingGroup(c98920495.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c,tp)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return c98920495.matfilter1(c,tp) and c98920495.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return c98920495.matfilter1(pe:GetOwner(),tp) and c98920495.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(c98920495.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function c98920495.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil	 
	if mg then
		g1=mg:Filter(c98920495.matfilter1,nil,c,tp)
		g2=mg:Filter(c98920495.matfilter2,nil,c,tp)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c98920495.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
		g2=Duel.GetMatchingGroup(c98920495.matfilter2,tp,LOCATION_MZONE,0,nil,c,tp)
		g3=Duel.GetMatchingGroup(c98920495.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c,tp)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,c98920495.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
			tuc=t1:GetFirst()
		else
			tuc=pe:GetOwner()
			Group.FromCards(tuc):Select(tp,1,1,nil)
		end
	end
	tuc:RegisterFlagEffect(98920495,RESET_EVENT+0x1fe0000,0,1)
	local tsg=tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=tuc.tuner_filter
	if tuc.tuner_filter then tsg=tsg:Filter(f,nil) end
	local g=c98920495.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,c98920495.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c98920495.SynOperation(f1,f2,minct,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,smat,mg,min,max)			
				local g=e:GetLabelObject()
				c:SetMaterial(g)			
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
				g:DeleteGroup()   
			end
end
function c98920495.rmfilter(c,tp)
	return c:IsCode(98920495) and c:IsAbleToRemoveAsCost()
end
function c98920495.costfilter(c,e,tp)
	return c:IsDiscardable()
end
function c98920495.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c98920495.costfilter,tp,LOCATION_HAND,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,c98920495.costfilter,tp,LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
end
function c98920495.spfilter(c,e,tp)
	return c:IsSetCard(0x27) and not c:IsType(TYPE_TUNER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c98920495.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c98920495.spfilter,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c98920495.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c98920495.spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c98920495.cfilter(c,tp)
	return c:IsSummonPlayer(tp)
end
function c98920495.reccon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c98920495.cfilter,1,nil,1-tp)
end
function c98920495.recop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,LOCATION_MZONE,nil)
	local tc=tg:GetFirst()
	while tc do
		c:SetCardTarget(tc)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EXTRA_SYNCHRO_MATERIAL)
		e1:SetOwnerPlayer(tp)
		e1:SetValue(c98920495.matval)
		e1:SetCondition(c98920495.rrcon)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1)
		tc=tg:GetNext()
	end
end
function c98920495.rrcon(e)
	return e:GetOwner():IsHasCardTarget(e:GetHandler())
end
function c98920495.matval(e,c)
	return c:IsControler(e:GetOwnerPlayer())
end
function c98920495.setop(e,tp,eg,ep,ev,re,r,rp)
	local sg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c98920495.rmfilter),tp,LOCATION_GRAVE,0,1,1,nil)
	if sg:GetCount()>0 then
		  Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end