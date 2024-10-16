--灭绝链环傀儡 混沌破灭洪流龙
local m=40010254
local cm=_G["c"..m]
cm.named_with_linkjoker=1
cm.named_with_ChaosBreaker=1
function cm.linkjoker(c)
	local m=_G["c"..c:GetCode()]
	return m and (m.named_with_linkjoker or (Duel.IsPlayerAffectedByEffect(c:GetControler(),40010218) and m.named_with_Reverse and c:IsLocation(LOCATION_MZONE+LOCATION_HAND)))
end
function cm.ChaosBreaker(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_ChaosBreaker
end
function cm.initial_effect(c)
	--Synchro summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)  
	--add type
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(cm.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--search
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.spcon)
	e3:SetCost(cm.spcost)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
end

function cm.CheckGroup(g,f,cg,min,max,...)
	if cg then Duel.SetSelectedCard(cg) end
	return g:CheckSubGroup(f,min,max,...)
end
function cm.SelectGroupNew(tp,desc,cancelable,g,f,cg,min,max,...)
	local min=min or 1
	local max=max or #g
	local ext_params={...}
	if cg then Duel.SetSelectedCard(cg) end
	Duel.Hint(tp,HINT_SELECTMSG,desc)
	return g:SelectSubGroup(tp,f,cancelable,min,max,...)
end
function cm.SelectGroup(tp,desc,g,f,cg,min,max,...)
	return cm.SelectGroupNew(tp,desc,false,g,f,cg,min,max,...)
end
function cm.matfilter1(c,syncard,tp)
	if c:IsFacedown() then return false end
	if c:IsSynchroType(TYPE_LINK) and cm.linkjoker(c) and c:IsControler(tp) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.matfilter2(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsCanBeSynchroMaterial(syncard)
end
function cm.val(c,syncard)
	if c:IsSynchroType(TYPE_LINK) then
		return c:GetLink()
	else
		return c:GetSynchroLevel(syncard)
	end
end
function cm.CheckGroupRecursive(c,sg,g,f,min,max,ext_params)
	sg:AddCard(c)
	local ct=sg:GetCount()
	local res=(ct>=min and f(sg,table.unpack(ext_params)))
		or (ct<max and g:IsExists(cm.CheckGroupRecursive,1,sg,sg,g,f,min,max,ext_params))
	sg:RemoveCard(c)
	return res
end
function cm.synfilter(c,syncard,lv,g2,g3,minc,maxc,tp)
	local tsg=c:IsHasEffect(EFFECT_HAND_SYNCHRO) and g3 or g2
	local f=c.tuner_filter
	if c.tuner_filter then tsg=tsg:Filter(f,nil) end
	return cm.CheckGroup(tsg,cm.goal,Group.FromCards(c),minc,maxc,tp,lv,syncard,c)
end
function cm.goal(g,tp,lv,syncard,tuc)
	if Duel.GetLocationCountFromEx(tp,tp,g,syncard)<=0 then return false end
	if tuc:IsHasEffect(EFFECT_HAND_SYNCHRO) and g:IsExists(Card.IsLocation,2,tuc,LOCATION_HAND) then return false end
	local ct=g:GetCount()
	return g:CheckWithSumEqual(cm.val,lv,ct,ct,syncard) and g:IsContains(tuc)
end
function cm.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,tp)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local sg=nil
	if tuner then
		return cm.matfilter1(c,tp) and cm.synfilter(tuner,c,lv,g2,g3,minc,maxc,tp)
	elseif pe then
		return cm.matfilter1(pe:GetOwner(),tp) and cm.synfilter(pe:GetOwner(),c,lv,g2,g3,minc,maxc,tp)
	else
		return g1:IsExists(cm.synfilter,1,nil,c,lv,g2,g3,minc,maxc,tp)
	end
end
function cm.syntg(e,tp,eg,ep,ev,re,r,rp,chk,c,tuner,mg)
	local minc=2
	local maxc=c:GetLevel()
	local g1=nil
	local g2=nil
	local g3=nil
	if mg then
		g1=mg:Filter(cm.matfilter1,nil,c,tp)
		g2=mg:Filter(cm.matfilter2,nil,c)
		g3=g2:Clone()
	else
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,nil,c)
	end
	local pe=Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	local tuc=nil
	if tuner then
		tuner=tuc
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		if not pe then
			local t1=g1:FilterSelect(tp,cm.synfilter,1,1,nil,c,lv,g2,g3,minc,maxc,tp)
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
	local g=cm.SelectGroup(tp,HINTMSG_SMATERIAL,tsg,cm.goal,Group.FromCards(tuc),minc,maxc,tp,lv,c,tuc)
	if g then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function cm.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local g=e:GetLabelObject()
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end
function cm.vafilter(c)
	return cm.ChaosBreaker(c)
end
function cm.valcheck(e,c)
	local g=c:GetMaterial()
	if g:IsExists(cm.vafilter,1,nil) then
		e:GetLabelObject():SetLabel(1)
	else
		e:GetLabelObject():SetLabel(0)
	end
end
function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabel()==1
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	c:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,1))
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.atkcfilter(c)
	return cm.linkjoker(c) and c:IsAbleToRemoveAsCost()
end
function cm.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil)  and Duel.IsExistingMatchingCard(cm.atkcfilter,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.atkcfilter,tp,LOCATION_EXTRA,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(1-tp,LOCATION_HAND,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,1-tp,2)
end
function cm.filter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)<=0 then return end
	--Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
	local ft2=nil
	if not (Duel.IsPlayerAffectedByEffect(1-tp,59822133) or Duel.GetLocationCount(1-tp,LOCATION_MZONE)==1) then ft2=2
	else
		ft2=1
	end

				--local g=Duel.SelectMatchingCard(1-tp,cm.filter,tp,0,LOCATION_HAND,ft2,ft2,nil,e,1-tp):RandomSelect(1-tp,2)
	local sg=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	local g=sg:RandomSelect(tp,ft2)
			  --  local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND):RandomSelect(1-tp,ft2)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			if not tc:GetType(TYPE_MONSTER) then
				local fid2=e:GetHandler():GetFieldID()
				local e1=Effect.CreateEffect(tc)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_CHANGE_TYPE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetValue(TYPE_NORMAL+TYPE_MONSTER)
				e1:SetReset(RESET_EVENT+0x47c0000)
				tc:RegisterEffect(e1,true)
				local e2=e1:Clone()
				e2:SetCode(EFFECT_REMOVE_RACE)
				e2:SetValue(RACE_ALL)
				tc:RegisterEffect(e2,true)
				local e3=e1:Clone()
				e3:SetCode(EFFECT_REMOVE_ATTRIBUTE)
				e3:SetValue(0xff)
				tc:RegisterEffect(e3,true)
				local e4=e1:Clone()
				e4:SetCode(EFFECT_SET_BASE_ATTACK)
				e4:SetValue(0)
				tc:RegisterEffect(e4,true)
				local e5=e1:Clone()
				e5:SetCode(EFFECT_SET_BASE_DEFENSE)
				e5:SetValue(0)
				tc:RegisterEffect(e5,true)
				tc:RegisterFlagEffect(m+1,RESET_EVENT+0x47c0000+RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET,0,1,fid2)
				tc:SetStatus(STATUS_NO_LEVEL,true)
				tc=g:GetNext()
			end
			Duel.SpecialSummon(tc,0,1-tp,1-tp,true,false,POS_FACEDOWN_ATTACK)
			--g:KeepAlive()
						Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_ATTACK)
						tc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET,0,1)
						local e6=Effect.CreateEffect(e:GetHandler())
						e6:SetDescription(aux.Stringid(m,2))
						e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
						e6:SetCode(EVENT_PHASE+PHASE_END)
						e6:SetCountLimit(1)
						e6:SetReset(RESET_PHASE+RESETS_STANDARD-RESET_TURN_SET)
						e6:SetCondition(cm.flipcon)
						e6:SetOperation(cm.flipop)
						e6:SetLabelObject(tc)
						Duel.RegisterEffect(e6,tp)
						local e7=Effect.CreateEffect(e:GetHandler())
						e7:SetType(EFFECT_TYPE_SINGLE)
						e7:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
						--e7:SetCondition(cm.rcon)
						e7:SetReset(RESET_EVENT+RESETS_STANDARD)
						Duel.RegisterEffect(e7,tp)
						local e8=Effect.CreateEffect(e:GetHandler())
						e8:SetType(EFFECT_TYPE_SINGLE)
						e8:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
						e8:SetReset(RESET_EVENT+RESETS_STANDARD)
						Duel.RegisterEffect(e8,tp)
						tc=g:GetNext()
		end
	end
end
function cm.flipcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc:IsFacedown() and Duel.GetTurnPlayer()==tc:GetControler() and tc:GetFlagEffect(m)~=0 and Duel.GetFlagEffect(tp,40010160)==0
end
function cm.flipop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.ChangePosition(tc,POS_FACEUP_ATTACK)
end
function cm.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(m+1)~=e:GetLabel() then
		e:Reset()
		return false
	else return true end
end
function cm.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end


