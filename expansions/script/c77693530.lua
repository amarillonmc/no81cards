--魅惑的女皇
function c77693530.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcCode3(c,87257460,23756165,50140163,false,false)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(77693530,0))
	e2:SetCategory(CATEGORY_EQUIP+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c77693530.eqcon)
	e2:SetTarget(c77693530.eqtg)
	e2:SetOperation(c77693530.eqop)
	c:RegisterEffect(e2)
	--return replace
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTarget(c77693530.reptg)
	e3:SetOperation(c77693530.repop)
	e3:SetValue(c77693530.repval)
	c:RegisterEffect(e3)
	--deck fusion material
	if not c77693530.globle_check then
		c77693530.globle_check=true
		_hack_fusion_check=Card.CheckFusionMaterial
		function Card.CheckFusionMaterial(card,Group_fus,Card_g,int_chkf,not_mat)
			local exg=Group.CreateGroup()
			if card:GetOriginalCode()==77693530 then
				exg=Duel.GetMatchingGroup(c77693530.filter0,int_chkf,LOCATION_DECK,0,nil)
				if exg:GetCount()>0 then
					Group_fus:Merge(exg)
				end
			end
			return _hack_fusion_check(card,Group_fus,Card_g,int_chkf,not_mat)
		end
	end
end
function c77693530.filter0(c)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial()
end
function c77693530.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER) and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function c77693530.filter(c,e,tp,lv)
	return c:IsSetCard(0x41) and c:IsLevelBelow(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c77693530.lv_or_rk_or_linkmark(c)
	if c:IsType(TYPE_XYZ) then return c:GetRank()
	elseif c:IsType(TYPE_LINK) then return c:GetLink()
	else return c:GetLevel() end
end
function c77693530.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=re:GetHandler()
	local lv=c77693530.lv_or_rk_or_linkmark(rc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c77693530.filter,tp,LOCATION_DECK,0,1,nil,e,tp,lv) and rc:IsRelateToEffect(re) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,rc,1,0,0)
end
function c77693530.eqop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if not (rc:IsControler(1-tp) and rc:IsRelateToEffect(re)) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local lv=c77693530.lv_or_rk_or_linkmark(rc)
	local g=Duel.SelectMatchingCard(tp,c77693530.filter,tp,LOCATION_DECK,0,1,1,nil,e,tp,lv)
	if g:GetCount()>0 then
		if Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)~=0 then
			Duel.Equip(tp,rc,g:GetFirst())
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_EQUIP_LIMIT)
			e2:SetLabelObject(g:GetFirst())
			e2:SetValue(c77693530.eqlimit)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			rc:RegisterEffect(e2)
		end
	end
end
function c77693530.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c77693530.repfilter(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsAttribute(ATTRIBUTE_DARK) and c:IsFaceup() and c:IsAbleToDeck()
end
function c77693530.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return rp~=tp and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(c77693530.repfilter),tp,LOCATION_GRAVE+LOCATION_MZONE,0,3,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(77693530,1)) then
		return true
	else return false end
end
function c77693530.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(c77693530.repfilter),tp,LOCATION_GRAVE+LOCATION_MZONE,0,3,3,nil)
	Duel.SendtoDeck(g,nil,3,REASON_EFFECT)
end
function c77693530.repval(e,c)
	return c==e:GetHandler() and c:IsLocation(LOCATION_MZONE) 
end
