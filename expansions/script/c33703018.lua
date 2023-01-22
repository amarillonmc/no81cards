--联动融合
local m=33703018
local cm=_G["c"..m]
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0):Filter(Card.IsType,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
	if chk==0 then return #g>0 end
end
function cm.f1(c)
	return not c:IsForbidden() 
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,0)
	local g1=Duel.GetFieldGroup(1-tp,LOCATION_EXTRA,0)
	local lose=false
	local close=false
	if g:FilterCount(Card.IsType,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)>0 then
		local tgp=1-tp
		local chkf=1-tp
		Duel.ConfirmCards(1-tp,g)
		Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_OPERATECARD)
		local setg=g:FilterSelect(tgp,Card.IsType,1,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
		if #setg==0 then return false end
		local tc=setg:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
		local min,max=aux.GetMaterialListCount(tc)
		local cong=Duel.GetMatchingGroup(Card.IsType,tgp,LOCATION_DECK,0,nil,TYPE_MONSTER)
		local maxfs=false
		if #cong==0 then return false end
		if  tc:IsType(TYPE_FUSION) and tc:CheckFusionMaterial(cong,nil,chkf) and max>0 and max>10 and Duel.SelectYesNo(tgp,aux.Stringid(m,1)) then
			Duel.SendtoGrave(tc,REASON_RULE)
			Duel.SendtoDeck(tc,tgp,SEQ_DECKSHUFFLE,REASON_RULE)
			mg=Duel.SelectFusionMaterial(1-tp,tc,cong,nil,chkf)
			maxfs=true
		else
			Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_CONFIRM)
			mg=cong:FilterSelect(tgp,cm.f1,1,#cong,nil)
		end
		Duel.ConfirmCards(tp,mg)
		if maxfs~=false then
			Duel.SendtoGrave(tc,REASON_RULE)
			Duel.SendtoDeck(tc,tc:GetOwner(),SEQ_DECKSHUFFLE,REASON_RULE)
		end
		Duel.ShuffleExtra(tp)
		--
		local mctchk=min>0 and max>0 and #mg==min 
		local xmctchk=min>0 and max>0 and #mg>min and max>10
		local spsum=Duel.GetLocationCountFromEx(tgp,tgp,nil,tc)>0 and tc:IsCanBeSpecialSummoned(e,0,tgp,false,false)
		local fschk=tc:IsType(TYPE_FUSION) and spsum and tc:CheckFusionMaterial(mg,nil,chkf)
		local sychk=spsum and tc:IsSynchroSummonable(nil,mg,#mg-1,#mg-1)
		local xchk=spsum and tc:IsXyzSummonable(mg,#mg,#mg)
		local chk1=mg:FilterCount(Card.IsAbleToGrave,nil)==#mg
		if fschk and xmctchk and maxfs~=false and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			lose=true
		end
		if fschk and mctchk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			lose=true
		end
		if sychk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			lose=true
		end
		if xchk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			lose=true
		end   
	end
	if lose==true and #g1>0 then
		Duel.BreakEffect()
		local tgp=tp
		local chkf=tp
		Duel.ConfirmCards(tp,g1)
		Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_OPERATECARD)
		local setg=g1:FilterSelect(tgp,Card.IsType,1,1,nil,TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ)
		if #setg==0 then return false end
		local tc=setg:GetFirst()
		Duel.Hint(HINT_CARD,0,tc:GetOriginalCodeRule())
		local min,max=aux.GetMaterialListCount(tc)
		local cong=Duel.GetMatchingGroup(Card.IsType,tgp,LOCATION_DECK,0,nil,TYPE_MONSTER)
		local maxfs=false
		if #cong==0 then return false end
		if  tc:IsType(TYPE_FUSION) and tc:CheckFusionMaterial(cong,nil,chkf) and max>0 and max>10 and Duel.SelectYesNo(tgp,aux.Stringid(m,1)) then
			Duel.SendtoGrave(tc,REASON_RULE)
			Duel.SendtoDeck(tc,tp,SEQ_DECKSHUFFLE,REASON_RULE)
			mg=Duel.SelectFusionMaterial(tp,tc,cong,nil,chkf)
			maxfs=true
		else
			Duel.Hint(HINT_SELECTMSG,tgp,HINTMSG_CONFIRM)
			mg=cong:FilterSelect(tgp,cm.f1,1,#cong,nil)
		end
		Duel.ConfirmCards(1-tp,mg)
		if maxfs~=false then
			Duel.SendtoGrave(tc,REASON_RULE)
			Duel.SendtoDeck(tc,tc:GetOwner(),SEQ_DECKSHUFFLE,REASON_RULE)
		end
		Duel.ShuffleExtra(1-tp)
		--
		local mctchk=min>0 and max>0 and #mg==min 
		local xmctchk=min>0 and max>0 and #mg>min and max>10
		local spsum=Duel.GetLocationCountFromEx(tgp,tgp,nil,tc)>0 and tc:IsCanBeSpecialSummoned(e,0,tgp,false,false)
		local fschk=tc:IsType(TYPE_FUSION) and spsum and tc:CheckFusionMaterial(mg,nil,chkf)
		local sychk=spsum and tc:IsSynchroSummonable(nil,mg,#mg-1,#mg-1)
		local xchk=spsum and tc:IsXyzSummonable(mg,#mg,#mg)
		local chk1=mg:FilterCount(Card.IsAbleToGrave,nil)==#mg
		if fschk and xmctchk and maxfs~=false and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			close=true
		end
		if fschk and mctchk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			close=true
		end
		if sychk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			close=true
		end
		if xchk and chk1 and Duel.SelectYesNo(tgp,aux.Stringid(m,0)) then
			Duel.BreakEffect()
			if Duel.SendtoGrave(mg,REASON_EFFECT)==0 then return false end
			Duel.SpecialSummon(tc,0,tgp,tgp,false,false,POS_FACEUP)
			close=true
		end   
	end
	if close==false and lose==false then
		Duel.Damage(1-tp,1000,REASON_EFFECT,true)
		Duel.Damage(tp,1000,REASON_EFFECT,true)
		Duel.RDComplete()
	elseif lose==true and close==false then
		Duel.Damage(tp,1000,REASON_EFFECT)
	end
end