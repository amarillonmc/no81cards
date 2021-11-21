--融合升华单元
if not pcall(function() require("expansions/script/c16199990") end) then require("script/c16199990") end
local m=16101151
local cm=_G["c"..m]
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetCountLimit(1,m)
	e1:SetCondition(cm.con)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_ADJUST)
	e2:SetRange(0x7f)
	e2:SetOperation(cm.op1)
	c:RegisterEffect(e2)
end
function cm.filter1(c)
	return c:IsType(TYPE_FUSION)
end
function cm.op1(e,tp)
	aux.AddFusionProcCode2=_tmp
	aux.AddFusionProcCode2FunRep=_tmp_1
	aux.AddFusionProcCode3=_tmp_2
	aux.AddFusionProcCode4=_tmp_3
	aux.AddFusionProcCodeFun=_tmp_4
	aux.AddFusionProcCodeFunRep=_tmp_5
	aux.AddFusionProcCodeRep=_tmp_6
	aux.AddFusionProcCodeRep2=_tmp_7
	aux.AddFusionProcFun2=_tmp_8
	aux.AddFusionProcFunFun=_tmp_9
	aux.AddFusionProcFunFunRep=_tmp_0
	aux.AddFusionProcFunRep=_tmp_1_0
	aux.AddFusionProcFunRep2=_tmp_1_1
	aux.AddFusionProcMix=_tmp_1_2
	aux.AddFusionProcMixRep=_tmp_1_3
	aux.AddFusionProcShaddoll=_tmp_1_4
end
_tmp=aux.AddFusionProcCode2
_tmp_1=aux.AddFusionProcCode2FunRep
_tmp_2=aux.AddFusionProcCode3
_tmp_3=aux.AddFusionProcCode4
_tmp_4=aux.AddFusionProcCodeFun
_tmp_5=aux.AddFusionProcCodeFunRep
_tmp_6=aux.AddFusionProcCodeRep
_tmp_7=aux.AddFusionProcCodeRep2
_tmp_8=aux.AddFusionProcFun2
_tmp_9=aux.AddFusionProcFunFun
_tmp_0=aux.AddFusionProcFunFunRep
_tmp_1_0=aux.AddFusionProcFunRep
_tmp_1_1=aux.AddFusionProcFunRep2
_tmp_1_2=aux.AddFusionProcMix
_tmp_1_3=aux.AddFusionProcMixRep
_tmp_1_4=aux.AddFusionProcShaddoll
function aux.AddFusionProcCode2(c,code1,code2,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp(c,code1,code2,sub,insf)
end
function aux.AddFusionProcCode2FunRep(c,code1,code2,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2+min
	end
	return _tmp_1(c,code1,code2,f,min,max,sub,insf)
end
function aux.AddFusionProcCode3(c,code1,code2,code3,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=3
	end
	return _tmp_2(c,code1,code2,code3,sub,insf)
end
function aux.AddFusionProcCode4(c,code1,code2,code3,code4,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=4
	end
	return _tmp_3(c,code1,code2,code3,code4,sub,insf)
end
function aux.AddFusionProcCodeFun(c,code1,f,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=1+cc
	end
	return _tmp_4(c,code1,f,cc,sub,insf)
end
function aux.AddFusionProcCodeFunRep(c,code1,f,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_5(c,code1,f,min,max,sub,insf)
end
function aux.AddFusionProcCodeRep(c,code1,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_6(c,code1,cc,sub,insf)
end
function aux.AddFusionProcCodeRep2(c,code1,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_7(c,code1,min,max,sub,insf)
end
function aux.AddFusionProcFun2(c,f,f1,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_8(c,f,f1,insf)
end
function aux.AddFusionProcFunFun(c,f1,f2,cc,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc+1
	end
	return _tmp_9(c,f1,f2,cc,sub,insf)
end
function aux.AddFusionProcFunFunRep(c,f1,f2,min,max,sub,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min+1
	end
	return _tmp_0(c,f1,f2,min,max,sub,insf)
end
function aux.AddFusionProcFunRep2(c,f,min,max,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_1(c,f,min,max,insf)
end
function aux.AddFusionProcFunRep(c,f,cc,insf)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=cc
	end
	return _tmp_1_0(c,f,cc,insf)
end
function aux.AddFusionProcMix(c,sub,insf,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	local val={...}
	local sum=#val 
	if not c.fst then
		ccodem.fst=sum
	end
	return _tmp_1_2(c,sub,insf,...)
end
function aux.AddFusionProcMixRep(c,sub,insf,f1,min,max,...)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=min
	end
	return _tmp_1_3(c,sub,insf,f1,min,max,...)
end
function aux.AddFusionProcShaddoll(c,att)
	local code=c:GetOriginalCode()
	if not _G["c"..code] then _G["c"..code]={}
		setmetatable(_G["c"..code],Card)
		_G["c"..code].__index=_G["c"..code]
	end
	local ccodem=_G["c"..code]
	if not c.fst then
		ccodem.fst=2
	end
	return _tmp_1_4(c,att)
end
function cm.rfilter(c,tp)
	return c:IsCode(m) and c:IsAbleToRemove() and (not c:IsLocation(LOCATION_ONFIELD) or c:IsFaceup()) and Duel.GetLocationCountFromEx(tp,tp,c)>0
end
function cm.spfilter(c,e,tp)
	if c.fst==nil then return false end
	return c:IsType(TYPE_FUSION) and Duel.GetMatchingGroupCount(cm.rfilter,tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,tp)>=c.fst and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false)
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler():IsCode(24094653)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,0,tp,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local rg=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.rfilter),tp,LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE,0,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()>0 then
		local tc=sg:GetFirst()
		local num=tc.fst
		Duel.Hint(HINT_MESSAGE,tp,HINTMSG_REMOVE)
		local rg1=rg:Select(tp,num,num,nil)
		Duel.Remove(rg1,POS_FACEUP,REASON_FUSION+REASON_EFFECT+REASON_MATERIAL)
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
	end
end