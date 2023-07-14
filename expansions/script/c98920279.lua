--自然的神星兽
function c98920279.initial_effect(c)
	--Synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(98920279,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c98920279.syncon)
	e0:SetTarget(c98920279.syntg)
	e0:SetOperation(c98920279.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
--LA
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e2) 
--spsummon success
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920279,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c98920279.con)
	e2:SetTarget(c98920279.tg)
	e2:SetOperation(c98920279.op)
	c:RegisterEffect(e2)
	--material check
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MATERIAL_CHECK)
	e3:SetValue(c98920279.valcheck)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c98920279.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function c98920279.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function c98920279.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return c98920279.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function c98920279.matfilter1(c,syncard,tp)
	local sc=Duel.GetTurnPlayer()
	if c:IsFacedown() then return false end  
	if not c:IsControler(sc) then return false end  
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard)
end
function c98920279.matfilter2(c,syncard,tp)
	local sc=Duel.GetTurnPlayer()
	if c:IsSynchroType(TYPE_LINK) then return true end 
	if c:IsSynchroType(TYPE_XYZ) then return true end
	if not c:IsControler(sc) then return false end
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard)
end
function c98920279.val(c,syncard)
	if c:IsSynchroType(TYPE_LINK) then
		return c:GetLink()
	elseif c:IsSynchroType(TYPE_XYZ) then
		return c:GetRank()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function c98920279.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(c98920279.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function c98920279.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return c98920279.CheckGroup(tsg,c98920279.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function c98920279.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(c98920279.val,lv,ct,ct,syncard)
end
function c98920279.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c98920279.matfilter1,nil,c,tp)
		g2=mg:Filter(c98920279.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c98920279.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c98920279.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c98920279.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return c98920279.matfilter1(c,tp) and c98920279.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return c98920279.matfilter1(pe:GetOwner(),tp) and c98920279.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(c98920279.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function c98920279.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(c98920279.matfilter1,nil,c,tp)
		g2=mg:Filter(c98920279.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(c98920279.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(c98920279.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(c98920279.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,c98920279.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
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
	local g=c98920279.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,c98920279.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function c98920279.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function c98920279.valcheck(e,c)
	local ct=0
	local g=c:GetMaterial()
	for i,type in ipairs({TYPE_FUSION,TYPE_RITUAL,TYPE_SYNCHRO,TYPE_XYZ,TYPE_LINK}) do
		if g:IsExists(Card.IsType,1,nil,type) then
			ct=ct+1
		end
	end
	e:GetLabelObject():SetLabel(ct)
end
function c98920279.con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end
function c98920279.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	local con3,con5,con8,con10=nil
	if ct>=1 then
		con3=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_SZONE,LOCATION_SZONE,1,nil)
	end
	if ct>=2 then
		con5=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil)
	end
	if ct>=3 then
		con8=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
	end
	if ct>=4 then
		con10=Duel.GetFieldGroupCount(tp,LOCATION_HAND,LOCATION_HAND)>0
	end
	if ct==5 then
		con11=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_EXTRA,LOCATION_EXTRA,1,nil)
	end
	if chk==0 then return con3 or con5 or con8 or con10 or con11 end
	local cat=CATEGORY_REMOVE 
	e:SetCategory(cat)
	Duel.SetChainLimit(aux.FALSE)
end
function c98920279.filter1(c)
	return c:IsFaceup() and c:GetSequence()<5
end
function c98920279.op(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local tp=e:GetHandler():GetOwner()
	if ct>=1 then
		local g=Duel.GetMatchingGroup(c98920279.filter1,tp,LOCATION_SZONE,LOCATION_SZONE,nil)
		 if g:GetCount()>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>=2 then
		local g1=Duel.GetMatchingGroup(aux.NecroValleyFilter(Card.IsAbleToRemove),tp,LOCATION_GRAVE,LOCATION_GRAVE,nil)
		if g1:GetCount()>0 then
		   Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>=3 then
		local g2=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,aux.ExceptThisCard(e))
		if g2:GetCount()>0 then
		   Duel.Remove(g2,POS_FACEUP,REASON_EFFECT)
		end
	end
	if ct>=4 then
		local g3=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
		Duel.Remove(g3,POS_FACEUP,REASON_EFFECT)
	end
	if ct==5 then
		local g4=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
		Duel.Remove(g4,POS_FACEUP,REASON_EFFECT)
	end
end