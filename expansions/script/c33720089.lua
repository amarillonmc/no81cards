--[[
【日】交织的百合 白与黑
==【Ｏ Bonding Lilies - W.B.】==
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
Duel.LoadScript("glitchylib_doublesided.lua")
function s.initial_effect(c)
	aux.AddOrigDoubleSidedType(c)
	aux.AddDoubleSidedProc(c,SIDE_OBVERSE,id+1,id)
	--[[If this card is Normal or Special Summoned: Special Summon 1 "Ｏ Bonding Lilies - W.B." from your Deck, hand or GY to your opponent's field, then Transform that card, or, if you cannot, banish this card.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON|CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(s.sptg)
	e1:SetOperation(s.spop)
	c:RegisterEffect(e1)
	e1:SpecialSummonEventClone(c)
	--[[While your opponent controls "Bonding Lilies - B.W.", other monsters on the field cannot be destroyed by battle or card effects,
	but they cannot be Tributed or used as a material for a Special Summon from the Extra Deck.
	Otherwise, double all damage they take, also, each time they pay or lose LP, immediately inflict damage equal to that paid or lost amount to your opponent.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(s.econ)
	e2:SetTarget(s.etg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_UNRELEASABLE_SUM)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e5)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	c:RegisterEffect(e6)
	local e7=e2:Clone()
	e7:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	c:RegisterEffect(e7)
	local e8=e2:Clone()
	e8:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	c:RegisterEffect(e8)
	local e9=e2:Clone()
	e9:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	c:RegisterEffect(e9)
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_FIELD)
	e10:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e10:SetCode(EFFECT_CHANGE_DAMAGE)
	e10:SetRange(LOCATION_MZONE)
	e10:SetTargetRange(0,1)
	e10:SetCondition(aux.NOT(s.econ))
	e10:SetValue(s.doubleval)
	c:RegisterEffect(e10)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_PAY_LPCOST)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCondition(s.lpcon)
	e11:SetOperation(s.lpop)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EVENT_CUSTOM+id)
	c:RegisterEffect(e12)
	if not s.global_check then
		s.global_check=true
		local ge3=Effect.GlobalEffect()
		ge3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_CONTINUOUS)
		ge3:SetCode(EVENT_ADJUST)
		ge3:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
		ge3:SetOperation(s.createtoken)
		Duel.RegisterEffect(ge3,0)
		
		local _SetLP = Duel.SetLP
		
		Duel.SetLP = function(p,val)
			local lp=Duel.GetLP(p)
			_SetLP(p,val)
			local diff=Duel.GetLP(p)-lp
			if diff<0 then
				Duel.RaiseEvent(s.DummyToken,EVENT_CUSTOM+id,nil,0,0,p,-diff)
			end
		end
	
	end
end
function s.createtoken(e)
	s.DummyToken=Duel.CreateToken(0,0)
	e:Reset()
end

--E1
function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local res,eg1=Duel.CheckEvent(EVENT_TRANSFORMED)
		return not res or (aux.GetValueType(eg1)=="Group" and not eg1:IsContains(c)) or (aux.GetValueType(eg1)=="Card" and eg1~=c)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,c,1,tp,0)
end
function s.spfilter(c,e,tp)
	return c:IsCode(id) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:IsCanTransform(SIDE_REVERSE,e,tp,REASON_EFFECT)
end
function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rmchk=true
	if Duel.GetMZoneCount(1-tp,nil,tp)>0 then
		local tc=Duel.Select(HINTMSG_SPSUMMON,false,tp,aux.Necro(s.spfilter),tp,LOCATION_HAND|LOCATION_DECK|LOCATION_GRAVE,0,1,1,nil,e,tp):GetFirst()
		if tc and Duel.SpecialSummon(tc,0,tp,1-tp,false,false,POS_FACEUP)>0 and Duel.Transform(tc,SIDE_REVERSE,e,tp,REASON_EFFECT) then
			rmchk=false
		end
	end
	if rmchk and c:IsRelateToChain() then
		Duel.Remove(c,POS_FACEUP,REASON_EFFECT)
	end
end

--E2
function s.econ(e)
	return Duel.IsExists(false,aux.FaceupFilter(Card.IsCode,id+1),e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil)
end
function s.etg(e,c)
	return c~=e:GetHandler()
end
function s.fuslimit(e,c,st)
	return st==SUMMON_TYPE_FUSION
end

--E10
function s.doubleval(e,re,val,r,rp,rc)
	return val*2
end

--E11
function s.lpcon(e,tp,_,ep)
	return not Duel.IsExists(false,aux.FaceupFilter(Card.IsCode,id+1),e:GetHandlerPlayer(),0,LOCATION_MZONE,1,nil) and ep==1-tp
end
function s.lpop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,tp,id)
	Duel.Damage(1-tp,ev,REASON_EFFECT)
end