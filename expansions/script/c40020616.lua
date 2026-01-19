--银河眼灵魂龙
local s, id = GetID()

function s.initial_effect(c)
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetCost(s.tdcost)
	e1:SetTarget(s.tdtg)
	e1:SetOperation(s.tdop)
	c:RegisterEffect(e1)
	
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_DISABLE+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+100)
	e2:SetCondition(s.discon)
	e2:SetCost(s.discost)
	e2:SetTarget(s.distg)
	e2:SetOperation(s.disop)
	c:RegisterEffect(e2)
end

function s.GalPho(c)
	return c:IsSetCard(0x7b) or c:IsSetCard(0x55)
end

function s.tdcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end

function s.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,0,LOCATION_GRAVE)
end

function s.tdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(id,2)) 
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,nil)
	local tc=g:GetFirst()
	if tc then

		if tc:IsControler(tp) and s.GalPho(tc) and tc:IsAbleToHand() 
			and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then 
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,tc)
		else
			Duel.SendtoDeck(tc,nil,2,REASON_EFFECT)
		end
	end
end


function s.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp and re:IsActiveType(TYPE_MONSTER)
end

function s.discost(e,tp,eg,ep,ev,re,r,rp,chk)

	if chk==0 then return Duel.CheckRemoveOverlayCard(tp,1,0,1,REASON_COST) end
	Duel.RemoveOverlayCard(tp,1,0,1,1,REASON_COST)
end


function s.xyzfilter(c,e,tp,mc)

	return s.GalPho(c) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,mc,c)>0 
		and mc:IsCanBeXyzMaterial(c)
end

function s.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 

		if c:IsLocation(LOCATION_GRAVE) and not (Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and c:IsCanBeSpecialSummoned(e,0,tp,false,false)) then
			return false 
		end

		return Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp,c)
	end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	if c:IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	end
end

function s.matfilter(c)
	return c:IsSetCard(0x107b) and c:IsType(TYPE_MONSTER)
end

function s.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	
	if Duel.NegateEffect(ev) then

		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_GRAVE) then
			if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)==0 then
				return 
			end
		end
		
		if c:IsRelateToEffect(e) and c:IsLocation(LOCATION_MZONE) and c:IsFaceup() and not c:IsImmuneToEffect(e) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=Duel.SelectMatchingCard(tp,s.xyzfilter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,c)
			local sc=g:GetFirst()
			if sc then
				sc:SetMaterial(Group.FromCards(c))
				Duel.Overlay(sc,Group.FromCards(c))
				if Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)>0 then
					sc:CompleteProcedure()
					
					if Duel.IsExistingMatchingCard(aux.NecroValleyFilter(s.matfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
						and Duel.SelectYesNo(tp,aux.Stringid(id,4)) then 
						
						Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
						local matg=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(s.matfilter),tp,LOCATION_HAND+LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
						if matg:GetCount()>0 then
							Duel.Overlay(sc,matg)
						end
					end
				end
			end
		end
	end
end