--龙唤士 罗莎
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			pcall(require_list[str])
			return require_list[str]
		end
		return require_list[str]
	end
end
if not pcall(function() require("expansions/script/c130005101") end) then require("script/c130005101") end
local m,cm=rscf.DefineCard(130005107,"DragonCaller")
function cm.initial_effect(c)
	local e1=rsef.STO(c,EVENT_SUMMON_SUCCESS,{m,0},nil,"sp","de",nil,nil,rsop.target(cm.spfilter,"sp",LOCATION_GRAVE),cm.spop)
	local e2=rsef.RegisterClone(c,e1,"code",EVENT_SPSUMMON_SUCCESS)
	local e3=rsef.STO(c,EVENT_RELEASE,{m,1},nil,"th","de",nil,nil,cm.tg,cm.op)
	--effect gain
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BE_MATERIAL)
	e3:SetProperty(EFFECT_FLAG_EVENT_PLAYER)
	e3:SetCondition(cm.efcon)
	e3:SetOperation(cm.efop)
	c:RegisterEffect(e3)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end  
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,2,PLAYER_ALL,LOCATION_ONFIELD)
end
function cm.op(e,tp)
	local e1=rsef.FC({e:GetHandler(),tp},EVENT_PHASE+PHASE_END,{m,1},1,nil,nil,cm.thcon,cm.thop,rsreset.pend)
end
function cm.thcon(e,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return g:CheckSubGroup(rsgf.dnpcheck,2,2)
end
function cm.thop(e,tp)
	rshint.Card(m)
	local g=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	rshint.Select(tp,"th")
	local tg=g:SelectSubGroup(tp,rsgf.dnpcheck,false,2,2)
	Duel.HintSelection(tg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
end
function cm.spfilter(c,e,tp)
	return rscf.spfilter2(rsdc.IsSet)(c,e,tp)
end
function cm.spop(e,tp)
	rsop.SelectSpecialSummon(tp,aux.NecroValleyFilter(cm.spfilter),tp,LOCATION_GRAVE,0,1,1,nil,{},e,tp)
end
function cm.efcon(e,tp,eg,ep,ev,re,r,rp)
	return r & REASON_XYZ + REASON_LINK ~= 0
end
function cm.efop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(rc)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.sumsuc)
	rc:RegisterEffect(e1,true)
	if not rc:IsType(TYPE_EFFECT) then
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_ADD_TYPE)
		e2:SetValue(TYPE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		rc:RegisterEffect(e2,true)
	end
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	Duel.SetChainLimitTillChainEnd(cm.chainlm)
end
function cm.chainlm(e,rp,tp)
	return tp==rp
end