--幻影骑士团 染魂双刃
local cm,m,o=GetID()
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,3,2)
	c:EnableReviveLimit()
	--atk
	local e1=Effect.CreateEffect(c)
	--e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,m) 
	e1:SetCondition(cm.eqcon)
	e1:SetOperation(cm.eqop)
	c:RegisterEffect(e1)
	--search
	local e3=Effect.CreateEffect(c)
	--e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m+10000000)
	e3:SetTarget(cm.tgtg)
	e3:SetOperation(cm.tgop)
	c:RegisterEffect(e3)
end
function cm.eqfil(c)
	return c:IsSetCard(0xdb) and (c:IsType(TYPE_SPELL) or c:IsType(TYPE_TRAP))
end
function cm.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function cm.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(cm.eqfil,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil) end
end
function cm.eqop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler()
	local code={}
	for i=1,2 do
		if Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)>0 and Duel.GetMatchingGroupCount(cm.eqfil,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil) then
			if i==1 or Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
			local gc=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil):Select(tp,1,1,nil):GetFirst()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
			local egc=Duel.GetMatchingGroup(cm.eqfil,tp,LOCATION_DECK+LOCATION_REMOVED,0,nil):Select(tp,1,1,nil):GetFirst()
			if Duel.Equip(tp,egc,gc) then 
				--equip limit
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetCode(EFFECT_EQUIP_LIMIT)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetLabelObject(gc)
				e1:SetValue(cm.eqlimit)
				egc:RegisterEffect(e1)
				--atk up
				local e2=Effect.CreateEffect(gc)
				e2:SetType(EFFECT_TYPE_EQUIP)
				e2:SetCode(EFFECT_UPDATE_ATTACK)
				e2:SetValue(1000)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				egc:RegisterEffect(e2)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_FIELD)
				e3:SetCode(EFFECT_CANNOT_ACTIVATE)
				e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
				e3:SetTargetRange(1,0)
				e3:SetLabel(egc:GetCode())
				e3:SetTarget(cm.actlimit)
				e3:SetReset(RESET_PHASE+PHASE_END)
				Duel.RegisterEffect(e3,tp)
			end 
			end 
		end
	end 
end
function cm.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function cm.actlimit(e,re,tp) 
	local rc=re:GetHandler()
	return rc:IsCode(e:GetLabel())
end
function cm.tgfil(c)
	return c:IsSetCard(0xdb) and c:IsFaceup()
end
function cm.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfil,tp,LOCATION_ONFIELD,0,1,nil) and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_DECK,0,1,nil) end
end
function cm.tgop(e,tp,eg,ep,ev,re,r,rp) 
	local c=e:GetHandler() 
	local num=math.min(Duel.GetMatchingGroupCount(cm.tgfil,tp,LOCATION_ONFIELD,0,nil),Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_DECK,0,nil))
	if num==0 then return end
	local tabnum={}
	for i=1,num do 
		tabnum[i]=i  
	end
	local ac=Duel.AnnounceNumber(tp,table.unpack(tabnum))
	Duel.ConfirmDecktop(tp,ac)
	local g=Duel.GetDecktopGroup(tp,ac)
	if g:GetCount()>0 then
		local sg=g:Filter(cm.tgfilter,nil)
		Duel.SendtoGrave(sg,REASON_EFFECT)
	end
	Duel.ShuffleDeck(tp)
end
function cm.tgfilter(c)
	return c:IsAbleToGrave() and c:IsSetCard(0xdb)
end











