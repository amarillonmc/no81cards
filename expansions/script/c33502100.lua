--平静祥和的森林
--Suyuz=Suyuz or {}
local m=33502100
local cm=_G["c"..m]
Suyuz={}
Suyuz.loaded_metatable_list={}
--
function Suyuz.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=Suyuz.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			Suyuz.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function Suyuz.costgrave(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() end
	Duel.SendtoGrave(c,REASON_COST)
end

function Suyuz.tograve(c,cat,code,op,hop)
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(Suyuz.valcheck)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,0))
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,code)
	e1:SetCost(Suyuz.costgrave)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(code,2))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCountLimit(1)
	e2:SetCondition(Suyuz.sum)
	e2:SetOperation(Suyuz.hop)
	e2:SetLabelObject(e0)
	e2:SetLabel(code)
	c:RegisterEffect(e2)
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e9:SetCode(EVENT_CUSTOM)
	e9:SetRange(0x70)
	e9:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_SET_AVAILABLE)
	e9:SetCondition(Suyuz.cc)
	e9:SetOperation(op)
	c:RegisterEffect(e9)
	return e1,e2,e9
end

function Suyuz.fusli_i(c,cat,code,op,hop)
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(Suyuz.valcheckfusli)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,2))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1)
	e1:SetCondition(Suyuz.sumfus)
	e1:SetOperation(Suyuz.hopfus)
	e1:SetLabelObject(e0)
	e1:SetLabel(code)
	c:RegisterEffect(e1)
	return e1
end

function Suyuz.hop(e,tp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	if c:GetFlagEffect(code)==0 and c:GetFlagEffect(code+100)==0 then
	c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
	end
end

function Suyuz.hopfus(e,tp)
	local c=e:GetHandler()
	local code=e:GetLabel()
	local mat=c:GetMaterial()
	local matg=mat:Filter(Card.IsSetCard,nil,0x2a80)
	local matcode=matg:GetFirst() 
	if c:GetFlagEffect(code)==0 and c:GetFlagEffect(code+100)==0 then
	c:RegisterFlagEffect(code,RESET_EVENT+RESETS_STANDARD,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(m,0))
		while matcode do
		local mcode=matcode:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(mcode)==0 then
		c:CopyEffect(mcode,RESET_EVENT+0x1fe0000+EVENT_CHAINING,1)
		c:RegisterFlagEffect(mcode,RESET_EVENT+RESETS_STANDARD, EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(mcode,2))
		end
		matcode=matg:GetNext()
		end
	end
end

function Suyuz.gaincon(code)
	return function(e)
		return e:GetHandler():GetFlagEffect(code)>0 or e:GetHandler():GetFlagEffect(code+100)>0
	end
end
function Suyuz.cc(e,tp,eg,ep,ev,re,r,rp)
	return eg:GetFirst()==e:GetHandler()
end
function Suyuz.sum(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
		and e:GetLabelObject():GetLabel()~=0 and e:GetHandler():GetFlagEffect(code+100)==0
end

function Suyuz.sumfus(e,tp,eg,ep,ev,re,r,rp)
	local code=e:GetLabel()
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
		and e:GetLabelObject():GetLabel()~=0 and e:GetHandler():GetFlagEffect(code+100)==0
end

function Suyuz.valcheck(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:IsExists(Card.IsRace,1,nil,RACE_PLANT) then flag=1 end
	e:SetLabel(flag)
end

function Suyuz.valcheckfusli(e,c)
	local g=c:GetMaterial()
	local flag=0
	if g:IsExists(Card.IsSetCard,1,nil,0x2a80) then flag=1 end
	e:SetLabel(flag)
end