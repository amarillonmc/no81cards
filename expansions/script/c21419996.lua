--苏生灵摆
local s,id,o=GetID()

local OriPConditionFilter = Auxiliary.PConditionFilter
function s.PConditionFilter(c,e,tp,lscale,rscale,eset)
	if not Duel.IsPlayerAffectedByEffect(tp,id) then
		return OriPConditionFilter(c,e,tp,lscale,rscale,eset)
	end
	
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND+LOCATION_GRAVE) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>lscale and lv<rscale and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
		and (aux.PendulumChecklist&(0x1<<tp)==0 or aux.PConditionExtraFilter(c,e,tp,lscale,rscale,eset))
end
Auxiliary.PConditionFilter = s.PConditionFilter

local OriPendCondition = Auxiliary.PendCondition
function s.PendCondition(e,c,og)
	--Debug.Message("in my con")
	if c==nil then return true end
	local tp=c:GetControler()
	if not Duel.IsPlayerAffectedByEffect(tp,id) then
		return false
	end	

	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	if aux.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	if rpz==nil or c==rpz then return false end
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local loc=0
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND+LOCATION_GRAVE end
	if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
	if loc==0 then return false end
	local g=nil
	local graveg = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if og then
		og.Merge(graveg)
		g=og:Filter(Card.IsLocation,nil,loc)
	else
		g=Duel.GetFieldGroup(tp,loc,0)
	end
	return g:IsExists(Auxiliary.PConditionFilter,1,nil,e,tp,lscale,rscale,eset)
end
Auxiliary.PendCondition = s.PendCondition

local OriPendOperation = Auxiliary.PendOperation
function s.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	--Debug.Message("in my op")
	if not Duel.IsPlayerAffectedByEffect(tp,id) then
		return OriPendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	end	
	local rpz=Duel.GetFieldCard(tp,LOCATION_PZONE,1)
	local lscale=c:GetLeftScale()
	local rscale=rpz:GetRightScale()
	if lscale>rscale then lscale,rscale=rscale,lscale end
	local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
	local tg=nil
	local loc=0
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
	local ft=Duel.GetUsableMZoneCount(tp)
	local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
	if ect and ect<ft2 then ft2=ect end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		if ft1>0 then ft1=1 end
		if ft2>0 then ft2=1 end
		ft=1
	end
	if ft1>0 then loc=loc|(LOCATION_HAND+LOCATION_GRAVE) end
	if ft2>0 then loc=loc|LOCATION_EXTRA end
	local graveg = Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_GRAVE,0,nil,TYPE_MONSTER)
	if og then
		og.Merge(graveg)
		tg=og:Filter(Card.IsLocation,nil,loc):Filter(Auxiliary.PConditionFilter,nil,e,tp,lscale,rscale,eset)
	else
		tg=Duel.GetMatchingGroup(Auxiliary.PConditionFilter,tp,loc,0,nil,e,tp,lscale,rscale,eset)
	end
	local ce=nil
	local b1=aux.PendulumChecklist&(0x1<<tp)==0
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
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	aux.GCheckAdditional=Auxiliary.PendOperationCheck(ft1,ft2,ft)
	local g=tg:SelectSubGroup(tp,Auxiliary.TRUE,true,1,math.min(#tg,ft))
	aux.GCheckAdditional=nil
	if not g then return end
	if ce then
		Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
		ce:UseCountLimit(tp)
	else
		aux.PendulumChecklist=aux.PendulumChecklist|(0x1<<tp)
	end
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
	Duel.HintSelection(Group.FromCards(rpz))
end
Auxiliary.PendOperation = s.PendOperation


	
--Debug.Message("pre")
function s.initial_effect(c)

	if c:GetOriginalCode()==id then
		--adjust
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e0:SetCode(EVENT_ADJUST)
		e0:SetRange(0xff)
		e0:SetOperation(s.adjustop)
		c:RegisterEffect(e0)
	end

	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--change effect type
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(id)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(1,0)
	c:RegisterEffect(e2)
end

function s.filter(c)
	return c:IsType(TYPE_PENDULUM)
end

function s.adjustop(e,tp,eg,ep,ev,re,r,rp)
	--
	if not s.globle_check then
		s.globle_check=true
		local g=Duel.GetMatchingGroup(s.filter,0,0xff,0xff,nil)
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(tc)
			e1:SetDescription(aux.Stringid(id,0))
			e1:SetType(EFFECT_TYPE_FIELD)
			e1:SetCode(EFFECT_SPSUMMON_PROC_G)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetRange(LOCATION_PZONE)
			e1:SetCondition(Auxiliary.PendCondition)
			e1:SetOperation(Auxiliary.PendOperation)
			e1:SetValue(SUMMON_TYPE_PENDULUM)
			tc:RegisterEffect(e1)
			Duel.CreateToken(0,tc:GetOriginalCode())
			--Debug.Message(tc:GetOriginalCode())
		end
	end
end