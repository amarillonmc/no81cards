forced_to_extra={
	[0]=false,
	[1]=false
}
function tomain_condition(tp)
	return function(e)
		return not forced_to_extra[tp]
	end
end
function Auxiliary.PreloadUds()
	for tp=0,1 do
		local e1=Effect.GlobalEffect()
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetCode(EFFECT_EXTRA_TOMAIN_KOISHI)
		e1:SetCondition(tomain_condition(tp))
		e1:SetValue(1)
		Duel.RegisterEffect(e1,tp)
	end
	local e1=Effect.GlobalEffect()
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function()
		--Debug.Message(ctf)
		forced_to_extra[0]=false
		forced_to_extra[1]=false
	end)
	Duel.RegisterEffect(e1,0)
end
local old_fromex=Duel.GetLocationCountFromEx
function Duel.GetLocationCountFromEx(tp,...)
	local c=select(3,...)
    if not c or c:IsType(TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ) and c:IsFacedown() then
		return old_fromex(tp,...)
	end
	forced_to_extra[tp]=true
	local res1,res2=old_fromex(tp,...)
	--Debug.Message(forced_to_extra[tp] and 1 or 0)
	forced_to_extra[tp]=false
	return res1,res2
end
function Auxiliary.LinkOperation(f,minc,maxc,gf)
	return	function(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
				local g=e:GetLabelObject()
				c:SetMaterial(g)
				Auxiliary.LExtraMaterialCount(g,c,tp)
				Duel.SendtoGrave(g,REASON_MATERIAL+REASON_LINK)
				g:DeleteGroup()
				forced_to_extra[tp]=true
			end
end
function Auxiliary.PendCondition()
	return	function(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if Auxiliary.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				if rpz==nil or c==rpz then return false end
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				forced_to_extra[tp]=true
				if Duel.GetLocationCountFromEx(tp)>0 then loc=loc+LOCATION_EXTRA end
				forced_to_extra[tp]=false
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
			end
end
function Auxiliary.PendOperation()
	return	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
				local lscale=c:GetLeftScale()
				local rscale=rpz:GetRightScale()
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				forced_to_extra[tp]=true
				local ft2=Duel.GetLocationCountFromEx(tp)
				forced_to_extra[tp]=false
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale,eset)
				else
					tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
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
					tg=tg:Filter(Auxiliary.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				Auxiliary.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				Auxiliary.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:Reset()
				else
					Auxiliary.PendulumChecklist=Auxiliary.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
				forced_to_extra[tp]=true
			end
end
local old_spsummon_step=Duel.SpecialSummonStep
local old_spsummon=Duel.SpecialSummon
function Duel.SpecialSummonStep(c,...)
	local tp=select(3,...)
    if c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup() or c:IsType(TYPE_LINK)) then
		forced_to_extra[tp]=true
	end
	local res=old_spsummon_step(c,...)
	forced_to_extra[tp]=false
	return res
end
function Duel.SpecialSummon(g,...)
	local res=0
    local tg=nil
	if Auxiliary.GetValueType(g)=="Card" then
		tg=Group.FromCards(g)
    else
        tg=g:Clone()
	end
	local groups={}
	 groups[1]=tg:Filter(function(c)
         return c:IsLocation(LOCATION_EXTRA) and (c:IsType(TYPE_PENDULUM) and c:IsFaceup() or c:IsType(TYPE_LINK))
	end,nil)
	tg:Sub(groups[1])
	groups[2]=tg:Filter(function(c)
		return not c:IsLocation(LOCATION_EXTRA)
	end,nil)
	tg:Sub(groups[2])
	groups[3]=tg
	for i=1,3 do
		for tc in Auxiliary.Next(groups[i]) do
			if Duel.SpecialSummonStep(tc,...) then res=res+1 end
		end
	end
	Duel.SpecialSummonComplete()
	return res
end
