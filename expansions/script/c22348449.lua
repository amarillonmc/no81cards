--拉特金禁卫骑士 蝶兰
local m=22348449
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_SZONE)
	e1:SetTarget(c22348449.sptg)
	e1:SetOperation(c22348449.spop)
	c:RegisterEffect(e1)
	--Equip
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOGRAVE+CATEGORY_EQUIP)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,22348449)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCondition(c22348449.eqcon)
	e2:SetTarget(c22348449.eqtg)
	e2:SetOperation(c22348449.eqop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	--Equipeff
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_EQUIP)
	e4:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e4:SetValue(1)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_EQUIP)
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	e6:SetValue(1800)
	c:RegisterEffect(e6)
	
end
function c22348449.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:GetEquipTarget() and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c22348449.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	if Duel.Draw(tp,1,REASON_EFFECT)>0 then
		Duel.Recover(tp,1600,REASON_EFFECT)
	end
end
function c22348449.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsSummonPlayer,1,nil,1-tp)
end

function c22348449.eqfilter(c,e)
	return c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function c22348449.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local g=eg:Filter(c22348449.eqfilter,nil,e)
	if chkc then return g:IsContains(chkc) end
	if chk==0 then return #g>0 and Duel.IsPlayerCanDiscardDeck(tp,5) end
	local sg
	if g:GetCount()==1 then
		sg=g:Clone()
		Duel.SetTargetCard(sg)
	else
		Duel.Hint(HINTMSG_DESTROY,tp,HINTMSG_TARGET)
		sg=Duel.SelectTarget(tp,aux.IsInGroup,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil,g)
	end
end
function c22348449.teqfilter(c)
	return c:IsSetCard(0x970b) and c:IsType(TYPE_MONSTER) and not c:IsForbidden()
end
function c22348449.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if Duel.IsPlayerCanDiscardDeck(tp,5) then
		Duel.ConfirmDecktop(tp,5)
		local g=Duel.GetDecktopGroup(tp,5)
		if g:GetCount()>0 then
			Duel.DisableShuffleCheck()
			local cg=g:Filter(c22348449.teqfilter,nil)
			local ct=cg:GetCount()
			if cg and ct>0 and tc:IsFaceup() and ft>0 and Duel.SelectYesNo(tp,aux.Stringid(22348449,1)) then
				if ct>ft then
					ct=ft
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
				local cct=0
				local tg=cg:FilterSelect(tp,c22348449.teqfilter,1,ct,nil)
				local ec=tg:GetFirst()
				while ec do
					if Duel.Equip(tp,ec,tc)~=0 then 
						local e1=Effect.CreateEffect(e:GetHandler())
						e1:SetType(EFFECT_TYPE_SINGLE)
						e1:SetCode(EFFECT_EQUIP_LIMIT)
						e1:SetReset(RESET_EVENT+RESETS_STANDARD)
						e1:SetValue(c22348449.eqlimit)
						e1:SetLabelObject(tc)
						ec:RegisterEffect(e1)
				cct=cct+1 end
					ec=tg:GetNext()
				end
				g:Sub(tg)
			end
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
		end
	end
end
function c22348449.eqlimit(e,c)
	return c==e:GetLabelObject()
end