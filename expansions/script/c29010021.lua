--歌蕾蒂娅·碎漩狂舞
if not pcall(function() require("expansions/script/c29010000") end) then require("script/c29010000") end
local m,cm = rscf.DefineCard(29010021)
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,nil,8,2)
	local e1 = rsef.SV_Card(c,"code",29010017,"sr",rsloc.mg)
	local e2 = rsef.SC_Easy(c,EVENT_SPSUMMON_SUCCESS,"cd",
		rscon.sumtyps("xyz"),cm.regop)
	local e3 = rsef.QO(c,nil,{m,0},1,"tg",nil,LOCATION_MZONE,
		cm.mvcon,nil,cm.mvtg,cm.mvop)
end
--fix ocg bug

function Auxiliary.SequenceToGlobal(p,loc,seq)
	if p~=0 and p~=1 then
		return 0
	end
	if loc==LOCATION_MZONE then
		if seq<=6 then
			return 0x1<<(16*p+seq)
		else
			return 0
		end
	elseif loc == LOCATION_SZONE then
		if seq<=4 then
			return 0x100<<(16*p+seq)
		else
			return 0
		end
	else
		return 0
	end
end

function cm.cfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsType(TYPE_EFFECT)
end
function cm.regop(e,tp)
	local c = e:GetHandler()
	local og = c:GetMaterial():Filter(cm.cfilter,nil)
	for tc in aux.Next(og) do
		c:CopyEffect(tc:GetOriginalCodeRule(),rsrst.std)
	end
end
function cm.mvcon(e,tp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,29010017)
end
function cm.desfilter(c)
	return not c:IsLocation(LOCATION_SZONE) or c:GetSequence()<5
end
function cm.seqfilter(c,seq,loc)
	local cseq=c:GetSequence()
	local cloc=c:GetLocation()
	if seq <= 4 and cloc == loc and math.abs(cseq-seq) <= 1 then return true end 
	if seq <= 4 and cloc ~= loc and cseq == seq then return true end 
	if seq <= 4 and cloc == loc and loc == LOCATION_MZONE and cseq >= 5 and aux.MZoneSequence(cseq) == aux.MZoneSequence(seq) then return true end 
	if seq >= 5 and cloc == loc and loc == LOCATION_MZONE and aux.MZoneSequence(cseq) == aux.MZoneSequence(seq) then return true end
	return false
end
function cm.mvtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.IsExistingMatchingCard(cm.desfilter,tp,0,LOCATION_ONFIELD,1,nil) end
	local filter=0
	for i = 0, 6 do 
		if Duel.IsExistingMatchingCard(cm.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i,LOCATION_MZONE) then 
			filter = filter | ((2^i) * 0x10000)
		end
	end
	for i = 0, 4 do 
		if Duel.IsExistingMatchingCard(cm.seqfilter,tp,0,LOCATION_ONFIELD,1,nil,i,LOCATION_SZONE) then 
			filter = filter | ((2^i) * 0x100 * 0x10000)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local flag=Duel.SelectField(tp,1,0,LOCATION_ONFIELD,0xff7fff7f - filter) / 0x10000
	local sloc = flag >= 0x100 and LOCATION_SZONE or LOCATION_MZONE 
	local seq = math.log(flag >= 0x100 and flag/0x100 or flag,2)
	e:SetLabel(seq,sloc)
end
function cm.mvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local seq,sloc=e:GetLabel()
	local g=Duel.GetMatchingGroup(cm.seqfilter,tp,0,LOCATION_ONFIELD,nil,seq,sloc)
	if #g <= 0 then return end
	local loc = 0
	local zone = {[ LOCATION_SZONE ] = 0, [ LOCATION_MZONE ] = 0}
	for tc in aux.Next(g) do 
		loc = tc:GetLocation()
		zone[loc] = zone[loc]| aux.SequenceToGlobal(tc:GetControler(),loc,tc:GetSequence())
	end
	local dzone = zone[ LOCATION_SZONE ] | zone[ LOCATION_MZONE ]
	if dzone > 0 then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_DISABLE_FIELD)
		e2:SetReset(rsrst.ep)
		e2:SetValue(dzone)
		Duel.RegisterEffect(e2,tp)
	end
	local tg,tc 
	local ft,xzone,xzone2,uzone = 0,0,0,{[ LOCATION_SZONE ] = 0, [ LOCATION_MZONE ] = 0}
	repeat 
		ft = 0
		rshint.Select(tp,HINTMSG_OPERATECARD)
		tg = g:Select(1-tp,1,1,nil)
		Duel.HintSelection(tg)
		tc = tg:GetFirst()
		loc = tc:GetLocation()
		p = tc:GetControler()
		xzone  = xzone | uzone[loc]
		xzone = zone[loc] > 0x10000 and zone[loc]/0x10000 or zone[loc]
		xzone2 = xzone
		xzone = xzone > 0x100 and xzone/0x100 or xzone 
		ft = Duel.GetLocationCount(p,loc,PLAYER_NONE,LOCATION_REASON_TOFIELD,0x1f - xzone)
		if ft <= 0 then
			Duel.SendtoGrave(tc,REASON_RULE)
		else
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_TOZONE)
			ft=Duel.SelectDisableField(p,1,loc,0,xzone2)
			Duel.Hint(HINT_ZONE,1-p,ft)
			Duel.Hint(HINT_ZONE,p,ft)
			Duel.MoveSequence(tc,math.log(ft/(loc == LOCATION_SZONE and 0x100 or 0x1),2))
			uzone[loc] = uzone[loc] | (ft * (p == tp and 0x1 or 0x10000))
		end
		g:RemoveCard(tc)
	until #g == 0
end