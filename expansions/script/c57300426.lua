--pvz bt z Z科技磁暴履带车
Duel.LoadScript("c57300400.lua")
local s,id,o=GetID()
function s.initial_effect(c)
	Zombie_Characteristics_X(c)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetOperation(s.defop)
	c:RegisterEffect(e3)
end
function s.deffilter(c,tp)
	if c:IsLocation(LOCATION_FZONE) then return false end
	if not (c:IsDefenseAbove(1) and c:IsFaceup() and c:IsControler(1-tp) and not (c:GetFlagEffect(57300424)~=0)) then return false end
	if ((i==0 or i==2) and c:GetSequence()==5) or ((o==2 or i==4) and c:GetSequence()==6) then return true end
	return i+c:GetSequence()==5 or i+c:GetSequence()==3
end
function s.defop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsControler(tp) then return end
	local dis=c:GetSequence()
	local g=Duel.IsExistingMatchingCard(s.deffilter,tp,0,LOCATION_MZONE,1,nil,i)
	if g:GetCount()>0 then
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetCode(EFFECT_UPDATE_DEFENSE)
			e1:SetValue(c:GetAttack()*-1)
			tc:RegisterEffect(e1)
		end
	end
end