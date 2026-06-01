-- 黑塔-空间站-
--Duel.LoadScript("c.lua")

 


Heita=Heita or {}
Heita.loaded_metatable_list={}

if not Htcheck then
	Htcheck=1
	function Heita.Planeswalker(c)
		return not (c.isPlaneswalker and c:IsFaceup() and c:IsLocation(LOCATION_MZONE))
	end

	Heita.GetMatchingGroup=Duel.GetMatchingGroup
	Duel.GetMatchingGroup=function(f,player,s,o,ex,...)
		return Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetMatchingGroupCount=Duel.GetMatchingGroupCount
	Duel.GetMatchingGroupCount=function(f,player,s,o,ex,...)
		return #Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetAttacker=Duel.GetAttacker
	Duel.GetAttacker=function()
		local tc=Heita.GetAttacker()
		if tc and tc.isPlaneswalker and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			return nil else return tc end
	end

	Heita.GetAttackerTarget=Duel.GetAttackerTarget
	Duel.GetAttackerTarget=function()
		local tc=Heita.GetAttackerTarget()
		if tc and tc.isPlaneswalker and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			return nil else return tc end
	end

	Heita.GetBattleMonster=Duel.GetBattleMonster
	Duel.GetBattleMonster=function(player)
		local tc=Heita.GetBattleMonster()
		if tc and tc.isPlaneswalker and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			return nil else return tc end
	end

	Heita.GetFieldCard=Duel.GetFieldCard
	Duel.GetFieldCard=function(player,location,seq)
		local tc=Heita.GetFieldCard(player,location,seq)
		if tc and tc.isPlaneswalker and tc:IsFaceup() and tc:IsLocation(LOCATION_MZONE) then
			return nil else return tc end
	end

	Heita.GetFieldGroup=Duel.GetFieldGroup
	Duel.GetFieldGroup=function(player,s,o)
		return Heita.GetFieldGroup(player,s,o):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetFieldGroupCount=Duel.GetFieldGroupCount
	Duel.GetFieldGroupCount=function(player,s,o)
		return #Heita.GetFieldGroup(player,s,o):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetFirstMatchingCard=Duel.GetFirstMatchingCard
	Duel.GetFirstMatchingCard=function(f,player,s,o,ex,...)
		return Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil):GetFirst()
	end

	Heita.GetLinkedGroup=Duel.GetLinkedGroup
	Duel.GetLinkedGroup=function(player,s_range,o_range)
		return Heita.GetLinkedGroup(player,s_range,o_range):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetLinkedGroupCount=Duel.GetLinkedGroupCount
	Duel.GetLinkedGroupCount=function(player,s_range,o_range)
		return #Heita.GetLinkedGroup(player,s_range,o_range):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetReleaseGroup=Duel.GetReleaseGroup
	Duel.GetReleaseGroup=function(player,...)
		return Heita.GetReleaseGroup(player,...):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetReleaseGroupCount=Duel.GetReleaseGroupCount
	Duel.GetReleaseGroupCount=function(player,...)
		return #Heita.GetReleaseGroup(player,...):Filter(Heita.Planeswalker,nil)
	end

	Heita.GetTargetCount=Duel.GetTargetCount
	Duel.GetTargetCount=function(f,player,s,o,ex,...)
		return #Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil)
	end

	Heita.SelectMatchingCard=Duel.SelectMatchingCard
	Duel.SelectMatchingCard=function(sel_player,f,player,s,o,min,max,ex,...)
		return Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil):Select(player,min,max,ex,...)
	end

	function Heita.PlaneswalkerRelease(c)
		return not (c.isPlaneswalker and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReleasable(REASON_COST))
	end

	Heita.SelectReleaseGroup=Duel.SelectReleaseGroup
	Duel.SelectReleaseGroup=function(sel_player,f,min,max,ex,...)
		return Heita.GetMatchingGroup(f,sel_player,LOCATION_MZONE,0,ex,...):Filter(Heita.PlaneswalkerRelease,nil):Select(sel_player,min,max,ex,...)
	end

	function Heita.PlaneswalkerRelease2(c,reason)
		return not (c.isPlaneswalker and c:IsFaceup() and c:IsLocation(LOCATION_MZONE) and c:IsReleasable(reason))
	end

	Heita.SelectReleaseGroupEx=Duel.SelectReleaseGroupEx
	Duel.SelectReleaseGroupEx=function(player,f,min,max,reason,use_hand,ex,...)
		local loc=LOCATION_MZONE
		if use_hand and use_hand~=0 then loc=LOCATION_HAND+LOCATION_MZONE end
		return Heita.GetMatchingGroup(f,sel_player,loc,0,ex,...):Filter(Heita.PlaneswalkerRelease2,nil,reason):Select(sel_player,min,max,ex,...)
	end

	Heita.SelectMatchingCard=Duel.SelectTarget
	Duel.SelectTarget=function(sel_player,f,player,s,o,min,max,ex,...)
		local sg=Heita.GetMatchingGroup(f,player,s,o,ex,...):Filter(Heita.Planeswalker,nil):Select(player,min,max,ex,...)
		Duel.SetTargetCard(sg)
		return sg
	end

	function Heita.PlaneswalkerS(c,f,...)
		return f and f(c,...) and Heita.Planeswalker(c)
	end

	Heita.IsExistingMatchingCard=Duel.IsExistingMatchingCard
	Duel.IsExistingMatchingCard=function(f,player,s,o,count,ex,...)
		return Heita.IsExistingMatchingCard(Heita.PlaneswalkerS,player,s,o,count,ex,f,...)
	end

	function Heita.PlaneswalkerS2(c,f,...)
		return f and f(c,...) and Heita.Planeswalker(c) and c:IsCanBeEffectTarget()
	end

	Heita.IsExistingTarget=Duel.IsExistingTarget
	Duel.IsExistingTarget=function(f,player,s,o,count,ex,...)
		return Heita.IsExistingTarget(Heita.PlaneswalkerS,player,s,o,count,ex,f,...)
	end

end




function Heita.endeff(c)
	local e1=Effect.CreateEffect(c)
  e1:SetCategory(CATEGORY_REMOVE)
  e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
  e1:SetCode(EVENT_PHASE+PHASE_END)
  e1:SetRange(LOCATION_MZONE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e1:SetCountLimit(1)
  e1:SetOperation(Heita.endeffop)
  c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE)
  e2:SetCode(EFFECT_UPDATE_ATTACK)
  e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
  e2:SetValue(Heita.atkval)
  c:RegisterEffect(e2)
	local e3=e2:Clone()
  e3:SetCode(EFFECT_UPDATE_DEFENSE)
  c:RegisterEffect(e3)
	--splimit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CAN_FORBIDDEN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetTarget(Heita.splimit)
	c:RegisterEffect(e4)
end
function Heita.endeffop(e,tp,eg,ep,ev,re,r,rp)
  local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_MZONE,0,nil)
  local ct=Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
  if ct==0 then
    Duel.Draw(tp,1,REASON_EFFECT)
  end
end
function Heita.atkval(e,c)
	local num=300
	if Duel.IsPlayerAffectedByEffect(c:GetOwner(),71290105) then num=num+200 end
	if Duel.IsPlayerAffectedByEffect(c:GetOwner(),71290111) then 
		local ug=Heita.GetMatchingGroup(Card.IsCode,c:GetOwner(),LOCATION_MZONE,0,nil,60010045)
		for uc in aux.Next(ug) do
			num=num+uc:GetLevel()*100
		end
	end
  return Duel.GetMatchingGroupCount(aux.TRUE,c:GetControler(),LOCATION_HAND,0,nil)*num
end
function Heita.splimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_EXTRA)
end
function Heita.atkfil(c)
	return c:GetAttack()
end
































local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,71290100)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(cm.damcon)
	e2:SetValue(0)
	c:RegisterEffect(e2)
end
function cm.filter(c)
	return aux.IsCodeListed(c,71290100) and c:IsAbleToHand() and c:IsType(TYPE_MONSTER)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.filter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function cm.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_MZONE,0,nil)<1
end