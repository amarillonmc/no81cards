--[[
【日】虚拟主播 铃木胜
【Ｏ】 VLiver Suzuki Masaru
Card Author: nemoma
Scripted by: XGlitchy30
]]

local s,id=GetID()
if not GLITCHYLIB_LOADED then
	Duel.LoadScript("glitchylib_vsnemo.lua")
end
Duel.LoadScript("glitchylib_doublesided.lua")
function s.initial_effect(c)
	c:EnableReviveLimit()
	aux.MustBeSpecialSummoned(c)
	aux.AddOrigDoubleSidedType(c)
	aux.AddDoubleSidedProc(c,SIDE_OBVERSE,id+1,id)
	--[[Must be Special Summoned (from your hand) by sending 2 monsters with 0 ATK or 0 DEF from your hand or field to the GY. If your opponent controls a monster(s) whose ATK or DEF were reduced to 0 by a card effect, you can also send those monsters to the GY for this card's Special Summon.]]
	local e1=Effect.CreateEffect(c)
	e1:Desc(0,id)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(s.sprcon)
	e1:SetTarget(s.sprtg)
	e1:SetOperation(s.sprop)
	c:RegisterEffect(e1)
	--[[All monsters your opponent controls lose 1200 ATK/DEF.]]
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(0,LOCATION_MZONE)
	e2:SetValue(-1200)
	c:RegisterEffect(e2)
	e2:UpdateDefenseClone(c)
	--If another "VLiver Suzuki Masaru(s)" is Special Summoned to your field: Transform 1 of those "VLiver Suzuki Masaru" into "VLiver Ruco".
	aux.RegisterMergedDelayedEventGlitchy(c,id,EVENT_SPSUMMON_SUCCESS,s.cfilter,id,LOCATION_MZONE,nil,LOCATION_MZONE,nil,nil,true)
	local e3=Effect.CreateEffect(c)
	e3:Desc(1,id)
	e3:SetType(EFFECT_TYPE_FIELD|EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_CUSTOM+id)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(s.trtg)
	e3:SetOperation(s.trop)
	c:RegisterEffect(e3)
	--You can only Special Summon "VLiver Suzuki Masaru(s)" up to twice per turn.
	Duel.AddCustomActivityCounter(id,ACTIVITY_SPSUMMON,function(c) return not (c:IsCode(id) and c:IsFaceup()) end)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD)
		ge1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge1:SetTargetRange(1,0)
		ge1:SetCondition(s.limcon(0))
		ge1:SetTarget(function(_,c) return c:IsCode(id) end)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.GlobalEffect()
		ge2:SetType(EFFECT_TYPE_FIELD)
		ge2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		ge2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
		ge2:SetTargetRange(0,1)
		ge2:SetCondition(s.limcon(1))
		ge2:SetTarget(function(_,c) return c:IsCode(id) end)
		Duel.RegisterEffect(ge2,0)
	end
end
--E0
function s.limcon(p)
	return	function(e)
				return Duel.GetCustomActivityCount(id,p,ACTIVITY_SPSUMMON)>=2
			end
end
--E1
function s.sprfilter(c,tp)
	local atkchk,defchk=c:IsAttack(0),c:IsDefense(0)
	return c:IsFaceupEx() and (atkchk or defchk) and c:IsAbleToGraveAsCost()
		and (c:IsControler(tp) or (atkchk and c:GetTextAttack()>0) or (defchk and c:GetTextDefense()>0))
end
function s.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND|LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	return g:CheckSubGroup(aux.mzctcheck,2,2,tp)
end
function s.sprtg(e,tp,eg,ep,ev,re,r,rp,chk,c)
	local g=Duel.GetMatchingGroup(s.sprfilter,tp,LOCATION_HAND|LOCATION_ONFIELD,LOCATION_MZONE,nil,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.mzctcheck,true,2,2,tp)
	if sg then
		sg:KeepAlive()
		e:SetLabelObject(sg)
		return true
	else return false end
end
function s.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=e:GetLabelObject()
	Duel.SendtoGrave(g,REASON_SPSUMMON)
	g:DeleteGroup()
end

--E3
function s.cfilter(c,e,tp,eg,ep,ev,re,r,rp,se,event)
	local h=e:GetHandler()
	return c~=h and c:IsFaceup() and c:IsCode(id) and c:IsControler(tp) and aux.AlreadyInRangeFilter(nil,nil,se)
end
function s.trtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not eg:IsContains(e:GetHandler()) end
	local g=eg:Filter(aux.FaceupFilter(Card.IsCode,id),nil)
	Duel.SetTargetCard(g)
end
function s.trfilter(c,e,tp)
	return c:IsFaceup() and c:IsCanTransform(SIDE_REVERSE,e,tp,REASON_EFFECT)
end
function s.trop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetTargetCards()
	if #g<=0 then return end
	Duel.HintMessage(tp,HINTMSG_FACEUP)
	local tg=g:FilterSelect(tp,s.trfilter,1,1,nil,e,tp)
	if #tg>0 then
		Duel.HintSelection(tg)
		Duel.Transform(tg:GetFirst(),SIDE_REVERSE,e,tp,REASON_EFFECT)
	end
end