local m=31400023
local cm=_G["c"..m]
cm.name="武神帝-惠比须"
function cm.initial_effect(c)
  c:SetUniqueOnField(1,0,31400023)
  aux.AddLinkProcedure(c,cm.linkfilter,1,1)
  c:EnableReviveLimit()
  local e0=Effect.CreateEffect(c)
  e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e0:SetCode(EVENT_SPSUMMON_SUCCESS)
  e0:SetRange(LOCATION_MZONE)
  e0:SetCondition(cm.lvlcon)
  e0:SetOperation(cm.lvlop)
  c:RegisterEffect(e0)
  local e1=Effect.CreateEffect(c)
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
  e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
  e1:SetValue(1)
  c:RegisterEffect(e1)
  local e2=Effect.CreateEffect(c)
  e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
  e2:SetCode(EVENT_SPSUMMON_SUCCESS)
  e2:SetCondition(cm.linksucon)
  e2:SetOperation(cm.extrasummonop)
  c:RegisterEffect(e2)
  local e3=Effect.CreateEffect(c)
  e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
  e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
  e3:SetProperty(EFFECT_FLAG_DELAY)
  e3:SetCode(EVENT_SUMMON_SUCCESS)
  e3:SetRange(LOCATION_MZONE)
  e3:SetCondition(cm.thspscon)
  e3:SetOperation(cm.thspsop)
  c:RegisterEffect(e3)
  local e4=Effect.CreateEffect(c)
  e4:SetType(EFFECT_TYPE_SINGLE)
  e4:SetCode(EFFECT_MATERIAL_CHECK)
  e4:SetValue(cm.matcheck)
  c:RegisterEffect(e4)
  e0:SetLabelObject(e4)
end
function cm.linkfilter(c)
	return c:IsSetCard(0x88) and not c:IsType(TYPE_LINK)
end
function cm.lvlcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_LINK 
end
function cm.lvlop(e,tp,eg,ep,ev,re,r,rp)
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetType(EFFECT_TYPE_SINGLE)
  e1:SetCode(EFFECT_XYZ_LEVEL)
  e1:SetValue(e:GetLabelObject():GetLabel())
  e1:SetReset(RESET_EVENT+RESETS_STANDARD)
  e:GetHandler():RegisterEffect(e1)
end
function cm.getlrfilter(c)
  if c:IsLevelAbove(0) then
	return c:GetLevel()
  end
  if c:IsRankAbove(0) then
	return c:GetRank()
  end
end
function cm.matcheck(e,c)
  e:SetLabel(cm.getlrfilter(c:GetMaterial():GetFirst()))
end
function cm.linksucon(e,tp,eg,ep,ev,re,r,rp)
  return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function cm.extrasummonop(e,tp,eg,ep,ev,re,r,rp)
  if Duel.GetFlagEffect(tp,31400023)~=0 then return end
  local e1=Effect.CreateEffect(e:GetHandler())
  e1:SetDescription(aux.Stringid(31400023,0))
  e1:SetType(EFFECT_TYPE_FIELD)
  e1:SetTarget(cm.extrasummonoptg)
  e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
  e1:SetCode(EFFECT_EXTRA_SUMMON_COUNT)
  e1:SetReset(RESET_PHASE+PHASE_END)
  Duel.RegisterEffect(e1,tp)
  Duel.RegisterFlagEffect(tp,31400023,RESET_PHASE+PHASE_END,0,1)
end
function cm.extrasummonoptg(e,c)
  return c:IsSetCard(0x88)
end
function cm.mzfilter(c,e,lg,tp)
  local race=c:GetRace()
  local id=c:GetCode()
  return c:IsSetCard(0x88) and lg:IsContains(c) and Duel.IsExistingMatchingCard(cm.deckfilter,tp,LOCATION_DECK,0,1,nil,e,race,id,tp)
end
function cm.deckfilter(c,e,race,id,tp)
  return c:IsSetCard(0x88) and c:GetRace()==race and c:GetCode()~=id and (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.thspscon(e,tp,eg,ep,ev,re,r,rp)
  local lg=e:GetHandler():GetLinkedGroup()
  return eg:IsExists(cm.mzfilter,1,nil,e,lg,tp)
end
function cm.thspsop(e,tp,eg,ep,ev,re,r,rp)
  Duel.Hint(HINT_SELECTMSG,tp,"")
  local lc=eg:GetFirst()
  local race=lc:GetRace()
  local id=lc:GetCode()
  local sg=Duel.SelectMatchingCard(tp,cm.deckfilter,tp,LOCATION_DECK,0,1,1,nil,e,race,id)
  local sc=sg:GetFirst()
  local ope=-1
  if sc then
  if (sc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0) then
	if sc:IsAbleToHand() then
	  if sc:IsAbleToGrave() then
		ope=Duel.SelectOption(tp,1152,1190,1191)
	  else
		ope=Duel.SelectOption(tp,1152,1190)
	  end
	else
	  if sc:IsAbleToGrave() then
		ope=Duel.SelectOption(tp,1152,1191)
		if ope==1 then
		  ope=2
		end
	  else
		ope=0
	  end
	end
  else
	if sc:IsAbleToHand() then
	  if sc:IsAbleToGrave() then
		ope=Duel.SelectOption(tp,1190,1191)
		ope=ope+1
	  else
		ope=2
	  end
	else
	  ope=2
	end
  end
  if ope==0 then
	Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
  else
	if ope==1 then
	Duel.SendtoHand(sc,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,sc)
	else
	Duel.SendtoGrave(sc,REASON_EFFECT)
	end
  end
  end
end