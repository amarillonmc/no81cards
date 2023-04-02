--方舟骑士-砾（Incomplete）
local m=29057860
local cm=_G["c"..m]
cm.named_with_Arknight=1
function cm.initial_effect(c)
	c:SetSPSummonOnce(29057860)
	if not Auxiliary.PendulumChecklist then
		Auxiliary.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(Auxiliary.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(cm.PendConditionArcKnight())
	e1:SetOperation(cm.PendOperationArcKnight())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--register by default
	if reg==nil or reg then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(1160)
		e2:SetType(EFFECT_TYPE_ACTIVATE)
		e2:SetCode(EVENT_FREE_CHAIN)
		e2:SetRange(LOCATION_HAND)
		e2:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
		c:RegisterEffect(e2)
	end

	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_PZONE)
	e3:SetCondition(cm.ArcKnightPCardCheck)
	e3:SetCode(29036036)
	e3:SetValue(function() return LOCATION_PZONE,cm.ArcKnightPCardFilter,1 end )
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetTarget(cm.ctltg)
	e4:SetOperation(cm.ctlop)
	c:RegisterEffect(e4)
	local e4_1=e4:Clone()
	e4_1:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e4_1)
	--

	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DESTROY_REPLACE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTarget(cm.desreptg)
	e6:SetValue(cm.desrepval)
	e6:SetOperation(cm.desrepop)
	c:RegisterEffect(e6)

	if not Pcheck_ArkKnight then
		Pcheck_ArkKnight = true
		Auxiliary.PendCondition = cm.PendConditionArcKnight
		Auxiliary.PendOperation = cm.PendOperationArcKnight
	end
end
function cm.repfilter(c,tp)
	return c:IsControler(tp) and c:IsOnField() and c:IsFaceup() and c:IsSetCard(0x87af)
		and c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
end
function cm.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(cm.repfilter,1,nil,tp)
		and c:IsAbleToHand() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_BATTLE_DESTROYED) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		c:SetStatus(STATUS_DESTROY_CONFIRMED,true)
		return true
	end
	return false
end
function cm.desrepval(e,c)
	return cm.repfilter(c,e:GetHandlerPlayer())
end
function cm.desrepop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local c=e:GetHandler()
	c:SetStatus(STATUS_DESTROY_CONFIRMED,false)
	Duel.SendtoHand(c,nil,REASON_EFFECT+REASON_REPLACE)
end
function cm.ctltg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=3 end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_DECK)
end
function cm.thfilter(c)
	return cm.ArcKnightPCardFilter(c) and (c:IsType(TYPE_PENDULUM) or c:IsAttribute(ATTRIBUTE_LIGHT)) and c:IsAbleToHand()
end
function cm.ctlop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<3 then return end
	Duel.ConfirmDecktop(tp,3)
	local g=Duel.GetDecktopGroup(tp,3)
	if g:GetCount()>0 then
		Duel.DisableShuffleCheck()
		if g:IsExists(cm.thfilter,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(tp,cm.thfilter,1,1,nil)
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
			Duel.ShuffleHand(tp)
			g:Sub(sg)
		end
		Duel.ShuffleDeck(tp)
	end
end
function cm.SetForceExtra(tp,res)
	if forced_to_extra then
		forced_to_extra[tp]=res
	end
end
function cm.PConditionFilterArcKnight(c,e,tp,lscale,rscale,f,tc,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and (Auxiliary.PendulumChecklist &(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
		and not c:IsForbidden() and (not f or f(c,tc))
end
function cm.GetPendulumCard(tp,seq)
	return Duel.GetFieldCard(tp,LOCATION_PZONE,seq)
end
function cm.PendConditionArcKnight()
	return  function(e,c,og,exfilter,flag)
				if c==nil then return true end
				local tp=c:GetControler()
				if not exfilter then exfilter = aux.TRUE end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 and not flag then return false end
				local rpz=cm.GetPendulumCard(tp,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local ft=Duel.GetUsableMZoneCount(tp)
				if ft<=0 then return false end
				local mft=Duel.GetMZoneCount(tp)
				cm.SetForceExtra(tp,true)
				local eft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				cm.SetForceExtra(tp,false)
				local g=nil
				if og then
					g=og:Filter(aux.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
				else
					g=Duel.GetMatchingGroup(aux.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale,eset)
				end
				local ext1={c:IsHasEffect(29036036)}
				local ext2={rpz:IsHasEffect(29036036)} 
				for i,te in pairs(ext1) do
					local location,filter,maxcount=te:GetValue()()  
					if (location==LOCATION_EXTRA and eft>0) or (location~=LOCATION_EXTRA and mft>0) then
						local exg=Duel.GetMatchingGroup(cm.PConditionFilterArcKnight,tp,location,0,nil,e,tp,lscale,rscale,filter,te:GetHandler(),eset)
						g:Merge(exg)
					end
				end
				for i,te in pairs(ext2) do
					local location,filter,maxcount=te:GetValue()()  
					if (location==LOCATION_EXTRA and eft>0) or (location~=LOCATION_EXTRA and mft>0) then
						local exg=Duel.GetMatchingGroup(cm.PConditionFilterArcKnight,tp,location,0,nil,e,tp,lscale,rscale,filter,te:GetHandler(),eset)
						g:Merge(exg)
					end
				end
				if mft<=0 then g=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA) end
				if eft<=0 then g:Remove(Card.IsLocation,nil,LOCATION_EXTRA) end
				if exfilter then
					g = g:Filter(exfilter,nil)
				end
				return #g>0
			end
end
function cm.PendCheckAdditionalArcKnight(mft,maxlist)
	return function(g)
		if mft>0 and g:IsExists(Card.IsLocation,mft+1,nil,0xbf) then return false end
		for loc,lct in pairs(maxlist) do
			if lct>0 and g:IsExists(Card.IsLocation,lct+1,nil,loc) then return false end
		end
		return true
	end
end
function cm.PendOperationArcKnight()
	return  function(e,tp,eg,ep,ev,re,r,rp,c,sg,og,exfilter,flag)
				local rpz=cm.GetPendulumCard(tp,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if not exfilter then exfilter = ArkEffect_Pend_filter or aux.TRUE end
				if lscale>rscale then lscale,rscale=rscale,lscale end
								local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local ft=Duel.GetUsableMZoneCount(tp)
				local mft=Duel.GetMZoneCount(tp)
				cm.SetForceExtra(tp,true)
				local eft=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				cm.SetForceExtra(tp,false)
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					mft=math.min(1,mft)
					mft=math.min(1,eft)
					ft=1
				end
				local tg=nil
				local maxlist={}
				if og then
					tg=og:Filter(aux.PConditionFilter,1,nil,e,tp,lscale,rscale)
				else
					tg=Duel.GetMatchingGroup(aux.PConditionFilter,tp,LOCATION_HAND+LOCATION_EXTRA,0,nil,e,tp,lscale,rscale,eset)
				end
				local ext1={c:IsHasEffect(29036036)}
				local ext2={rpz:IsHasEffect(29036036)}
				for i,te in pairs(ext1) do
					local location,filter,maxcount=te:GetValue()()
					if (location==LOCATION_EXTRA and eft>0) or (location~=LOCATION_EXTRA and mft>0) then
						local exg=Duel.GetMatchingGroup(cm.PConditionFilterArcKnight,tp,location,0,nil,e,tp,lscale,rscale,filter,te:GetHandler(),eset)
						tg:Merge(exg)
						local mct=maxcount
						if mct and mct>0 and mct<ft then
							maxlist[location]=mct
						end
					end
				end
				for i,te in pairs(ext2) do
					local location,filter,maxcount=te:GetValue()()   
					if (location==LOCATION_EXTRA and eft>0) or (location~=LOCATION_EXTRA and mft>0) then
						local exg=Duel.GetMatchingGroup(cm.PConditionFilterArcKnight,tp,location,0,nil,e,tp,lscale,rscale,filter,te:GetHandler(),eset)
						tg:Merge(exg)
						local mct=maxcount
						if mct and mct>0 and mct<ft then
							maxlist[location]=mct
						end
					end
				end
				if mft<=0 then tg=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA) end
				if eft<=0 then tg:Remove(Card.IsLocation,nil,LOCATION_EXTRA) end
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and math.min(c29724053[tp],eft) or eft
				local left=maxlist[LOCATION_EXTRA]
				if left then
					maxlist[LOCATION_EXTRA]=math.min(left,ect)
				else
					maxlist[LOCATION_EXTRA]=ect
				end
				local ce=nil
				local b1=Auxiliary.PendulumChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(aux.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				if exfilter then
					tg = tg:Filter(exfilter,nil)
				end
				Auxiliary.GCheckAdditional=cm.PendCheckAdditionalArcKnight(mft,maxlist)
				Duel.Hint(tp,HINT_SELECTMSG,desc)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,ft)
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:Reset()
				elseif ArkEffect_Pend then
					ArkEffect_Pend = false
				else
					Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
				cm.SetForceExtra(tp,true)
			end
end
function cm.ArcKnightPCardFilter(c)
	return (c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:IsType(TYPE_PENDULUM)
end
function cm.ArcKnightPCardCheck(e)
	return Duel.IsExistingMatchingCard(cm.ArcKnightPCardFilter,e:GetHandlerPlayer(),LOCATION_PZONE,0,1,e:GetHandler())
end
