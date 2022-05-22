--邪骨团 迷狂
local m=64800135
local cm=_G["c"..m]

Suyu_02_x=Suyu_02_x or {}
function Suyu_02_x.gi(c,code)
	local tc=c
	--summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,code)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0 end
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	local mg=Duel.GetMatchingGroup(function(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsType(TYPE_MONSTER) 
end,tp,LOCATION_HAND,0,nil)
	if mg:GetCount()>0 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=mg:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	end)
	tc:RegisterEffect(e1)
	return e1
end
function Suyu_02_x.geffect(c,code,tg,op,cat,pro)
	local tc=c
	--eff
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(code,2))
	e1:SetCategory(cat)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	if pro~=nil then
		e1:SetProperty(pro)
	end
	e1:SetCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetFlagEffect(tp,code)==0 end
		Duel.RegisterFlagEffect(tp,code,RESET_PHASE+PHASE_END,0,1)
	end)
	e1:SetTarget(tg)
	e1:SetOperation(op)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(function(e,c)
	local seq=e:GetHandler():GetSequence()
	local tp=e:GetHandlerPlayer()
	return c:IsType(TYPE_EFFECT) and c.setname=="Zx02"
		and aux.GetColumn(c,tp)==seq
	end)
	e3:SetLabelObject(e1)
	tc:RegisterEffect(e3)
	return e1,e3
end
-------------------------------
if not cm then return end
function cm.initial_effect(c)
	local e0=Suyu_02_x.gi(c,m)
	local e1,e2=Suyu_02_x.geffect(c,m,cm.tg,cm.op,CATEGORY_DECKDES+CATEGORY_SEARCH+CATEGORY_TOHAND)
end
cm.setname="Zx02"
function cm.thfilter(c)
	return c.setname=="Zx02" and (c:IsAbleToHand() or c:IsAbleToGrave())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()<=0 then return end
	local tc=g:GetFirst()
	if tc:IsAbleToHand() and (not tc:IsAbleToGrave() or Duel.SelectOption(tp,1190,1191)==0) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	else
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end
