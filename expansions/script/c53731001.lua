local m=53731001
local cm=_G["c"..m]
cm.name="狂喑祭月"
function cm.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetTarget(cm.sptg)
	e1:SetOperation(cm.spop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetTarget(cm.thtg)
	e2:SetOperation(cm.thop)
	c:RegisterEffect(e2)
end
function cm.RitualCheckEqual(g,mg)
	if mg:IsExists(Card.IsLevel,1,nil,0) then return false end
	local t1,t2,t3,t4={},{},{},{}
	for tc in aux.Next(mg) do
		local lv,ct=tc:GetLevel(),1
		if tc:IsLocation(LOCATION_GRAVE) then ct=2 end
		if tc:IsLocation(LOCATION_DECK) then ct=3 end
		local t5={lv*ct,lv*(ct+1)}
		if #t1~=0 then
			if #t2~=0 then
				if #t3~=0 then cm.insert(t4,t5)
				else cm.insert(t3,t5) end
			else cm.insert(t2,t5) end
		else cm.insert(t1,t5) end
	end
	if #t1==0 then t1={0,0} end
	if #t2==0 then t2={0,0} end
	if #t3==0 then t3={0,0} end
	if #t4==0 then t4={0,0} end
	local t={}
	for i1=1,#t1 do
		local x1=t1[i1]
		for i2=1,#t2 do
			local x1,x2=x1,t2[i2]
			for i3=1,#t3 do
				local x1,x2,x3=x1,x2,t3[i3]
				for i4=1,#t4 do
					local x1,x2,x3,x4=x1,x2,x3,t4[i4]
					table.insert(t,x1+x2+x3+x4)
				end
			end
		end
	end
	local res=false
	for i=1,#t do if g:CheckWithSumEqual(cm.TacitearRitLevel,t[i],#g,#g,mg) then res=true end end
	return res
end
function cm.insert(t,pt)
	for i=1,#pt do table.insert(t,pt[i]) end
end
function cm.TacitearRitLevel(c,g)
	local x=math.max(65535,c:GetLevel())
	for tc in aux.Next(g) do
		local lv=c:GetRitualLevel(tc)&0xffff
		if x>lv then x=lv end
	end
	if x>MAX_PARAMETER then
		return MAX_PARAMETER
	else
		return x
	end
end
function cm.RitualCheck(g,tp,mg)
	local res=true
	for tc in aux.Next(mg) do
		if tc.mat_group_check and not tc.mat_group_check(g,tp) then res=false end
		if aux.RCheckAdditional and not aux.RCheckAdditional(tp,g,tc) then res=false end
	end
	return cm.RitualCheckEqual(g,mg) and Duel.GetMZoneCount(tp,g,tp)>=#mg and res
end
function cm.RitualCheckAdditional(mg,lv)
	return  function(g)
				local slv=0
				for tc in aux.Next(g) do
					local xtc,clv=tc,65535
					for c in aux.Next(mg) do
						local xlv=aux.RitualCheckAdditionalLevel(xtc,c)
						if xlv<clv then clv=xlv end
					end
					slv=slv+clv
				end
				return (not aux.RGCheckAdditional or aux.RGCheckAdditional(g)) and slv<=lv
			end
end
function cm.ritfselect(g,tp,m1)
	local mg=m1:Clone()
	for c in aux.Next(g) do
		mg=mg:Filter(Card.IsCanBeRitualMaterial,c,c)
		if c.mat_filter then mg=mg:Filter(c.mat_filter,c,tp) else mg:RemoveCard(c) end
	end
	local lv=0
	for calc in aux.Next(g) do
		local ct=1
		if calc:IsLocation(LOCATION_GRAVE) then ct=2 end
		if calc:IsLocation(LOCATION_DECK) then ct=3 end
		lv=lv+calc:GetLevel()*(ct+1)
	end
	aux.GCheckAdditional=cm.RitualCheckAdditional(g,lv)
	local res=mg:CheckSubGroup(cm.RitualCheck,1,lv,tp,g)
	aux.GCheckAdditional=nil
	return res and #g<5 and aux.dncheck(g)
end
function cm.ritfilter(c,e,tp)
	return c:IsRace(RACE_FIEND) and c:IsLevelAbove(3) and c:GetType()&0x81==0x81 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true,POS_FACEUP)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetRitualMaterial(tp)
	mg:Remove(Card.IsLocation,nil,LOCATION_MZONE)
	local ritg=Duel.GetMatchingGroup(cm.ritfilter,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return false end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,4)
	if chk==0 then return ritg:CheckSubGroup(cm.ritfselect,1,math.min(#ritg,ct),tp,mg) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetRitualMaterial(tp)
	mg:Remove(Card.IsLocation,nil,LOCATION_MZONE)
	local rit=Duel.GetMatchingGroup(aux.NecroValleyFilter(cm.ritfilter),tp,LOCATION_DECK+LOCATION_GRAVE+LOCATION_HAND,0,nil,e,tp)
	local ct=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ct<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	ct=math.min(ct,4)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	if not rit:CheckSubGroup(cm.ritfselect,1,math.min(#rit,ct),tp,mg) then return end
	local ritg=rit:SelectSubGroup(tp,cm.ritfselect,false,1,math.min(#rit,ct),tp,mg)
	for tc in aux.Next(ritg) do
		mg=mg:Filter(Card.IsCanBeRitualMaterial,tc,tc)
		if tc.mat_filter then mg=mg:Filter(tc.mat_filter,tc,tp) else mg:RemoveCard(tc) end
	end
	local lv=0
	for calc in aux.Next(ritg) do
		local ct=1
		if calc:IsLocation(LOCATION_GRAVE) then ct=2 end
		if calc:IsLocation(LOCATION_DECK) then ct=3 end
		lv=lv+calc:GetLevel()*(ct+1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	aux.GCheckAdditional=cm.RitualCheckAdditional(ritg,lv)
	local mat=mg:SelectSubGroup(tp,cm.RitualCheck,false,1,lv,tp,ritg)
	aux.GCheckAdditional=nil
	if not mat or mat:GetCount()==0 then return end
	for fc in aux.Next(ritg) do fc:SetMaterial(mat) end
	Duel.ReleaseRitualMaterial(mat)
	Duel.BreakEffect()
	for fc in aux.Next(ritg) do
		Duel.SpecialSummonStep(fc,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		fc:CompleteProcedure()
	end
	Duel.SpecialSummonComplete()
end
function cm.thfilter(c,b1,b2)
	return ((b1 and c:IsAbleToHand()) or (b2 and c:IsAbleToDeck())) and c:IsRace(RACE_FIEND) and c:IsType(TYPE_RITUAL)
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	local c=e:GetHandler()
	local b1,b2=c:IsAbleToDeck(),c:IsAbleToHand()
	if chk==0 then return c:IsCanBeEffectTarget(e) and Duel.IsExistingTarget(cm.thfilter,tp,LOCATION_GRAVE,0,1,nil,b1,b2) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,cm.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,b1,b2)
	Duel.SetTargetCard(Group.__add(g,c))
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
	g:Sub(tg)
	Duel.SendtoHand(tg,nil,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,tg:GetFirst())
	Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
end
