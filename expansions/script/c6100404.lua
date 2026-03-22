--名川之龙神-四万十
local cm,m,o=GetID()
function cm.initial_effect(c)
	--同调召唤
	c:EnableReviveLimit()
	--SynchroSummon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	e0:SetCondition(cm.syncon)
	e0:SetTarget(cm.syntg)
	e0:SetOperation(cm.synop)
	c:RegisterEffect(e0)

	--①
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCondition(function(e,tp) return Duel.GetTurnPlayer()~=tp end)
	c:RegisterEffect(e2)

	--②
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetCode(m)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetTarget(function(e,c)return c:IsRace(RACE_DRAGON|RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_LIGHT)end)
	e3:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)return true end)
	c:RegisterEffect(e3)

	--②
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e4:SetCode(EVENT_ADJUST)
	e4:SetRange(LOCATION_MZONE)
	e4:SetOperation(cm.adjustop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SPSUMMON_SUCCESS)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) cm.grant_quick_effect(e:GetHandler(),tp) end)
	c:RegisterEffect(e5)

	--addition
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_DRAW)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_CHAINING)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,m+1)
	e6:SetCondition(cm.discon)
	e6:SetTarget(cm.distg)
	e6:SetOperation(cm.disop)
	c:RegisterEffect(e6)
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return bit.band(loc,LOCATION_ONFIELD)~=0
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
		and re:GetHandler()~=e:GetHandler()
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsDiscardable,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,Card.IsDiscardable,1,1,REASON_COST+REASON_DISCARD)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,2) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)==1 then
		Duel.ShuffleHand(p)
		Duel.BreakEffect()
		Duel.DiscardHand(p,nil,1,1,REASON_EFFECT+REASON_DISCARD)
	end
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
	if c:IsSynchroType(TYPE_LINK) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsControler(tp) then return true end 
	return c:IsSynchroType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(syncard) and c:IsAttribute(ATTRIBUTE_LIGHT)
end

function cm.matfilter2(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsNotTuner(syncard) and c:IsRace(RACE_DRAGON) and c:IsCanBeSynchroMaterial(syncard)
end

function cm.val(c,syncard)
	if c:IsSynchroType(TYPE_LINK) and c:IsRace(RACE_DRAGON) and c:IsAttribute(ATTRIBUTE_LIGHT) then
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
	return g:CheckWithSumEqual(cm.val,lv,ct,ct,syncard)
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
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,0,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
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
		g1=Duel.GetMatchingGroup(cm.matfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
		g2=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE,0,nil,c)
		g3=Duel.GetMatchingGroup(cm.matfilter2,tp,LOCATION_MZONE+LOCATION_HAND,0,nil,c)
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


function cm.thfilter(c)
	if not c:IsAbleToHand() then return false end
	local b1 = c:IsRace(RACE_DRAGON|RACE_SPELLCASTER|RACE_WARRIOR) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsLevel(1) and c:IsType(TYPE_TUNER)
	local b2 = c:IsRace(RACE_DRAGON) and c:GetAttack()==3000 and c:GetDefense()==2500
	return b1 or b2
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end


function cm.adjustop(e,tp,eg,ep,ev,re,r,rp)
	local c = e:GetHandler()

	if c:IsStatus(STATUS_SUMMONING|STATUS_SUMMON_DISABLED) then return end
	cm.grant_quick_effect(c, tp)
end

function cm.grant_quick_effect(c, tp)

	local g=Duel.GetMatchingGroup(function(tc,tp)
		return tc:IsRace(RACE_DRAGON|RACE_SPELLCASTER) and tc:IsAttribute(ATTRIBUTE_LIGHT) 
		and Duel.GetFlagEffect(tp,m+tc:GetOriginalCode())==0 
	end,tp,LOCATION_HAND,0,nil,tp)
	
	if #g==0 then return end
	
	for tc in aux.Next(g) do
		local code=tc:GetOriginalCode()
		if Duel.GetFlagEffect(tp,m+code)==0 then

			Duel.RegisterFlagEffect(tp,m+code,0,0,0)
			
			local cp={}
			local reg=Card.RegisterEffect

			Card.RegisterEffect=function(sc,se,bool)
				if se:GetType()&EFFECT_TYPE_IGNITION>0 and se:GetRange()&LOCATION_HAND>0 then 
					table.insert(cp,se:Clone()) 
				end
				return reg(sc,se,bool)
			end
			
			Duel.CreateToken(tp,code)
			Card.RegisterEffect=reg 
			
			for i,v in ipairs(cp) do

				v:SetCode(EVENT_FREE_CHAIN)
				v:SetType(EFFECT_TYPE_QUICK_O)
				v:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
				
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
				e1:SetTargetRange(LOCATION_HAND,0)
				e1:SetLabel(code)

				e1:SetTarget(function(eff,target_c) return target_c:IsOriginalCodeRule(eff:GetLabel()) and target_c:IsHasEffect(m) end)
				e1:SetLabelObject(v)
				Duel.RegisterEffect(e1,tp)
			end
		end
	end
end